`include "components.v"

// combination of output selector and tristate buffer
module outputpiece(
  input o_mux,
  input out, ffq, oe,
  output q
);

  wire output_wire;

  mux outmux(
    .mux(o_mux),
    .a0(ffq),
    .a1(out),
    .q(output_wire)
  );

  mux tristate(
    .mux(oe),
    .a0(1'bz),
    .a1(output_wire),
    .q(q)
  );
endmodule

// the macrocell storage element
module dff(
  input storage_mux,
  input ffd, ffclk, ffen, ffas, ffar,
  output ffq, ffqn
);
  
  wire qlatch, qff, q;

  // yosys doesn't let us trigger on both en and clk so
  // we just make both kinds of storage and choose one to use
  dff_flipflop ff_mode(.ffd(ffd), .ffclk(ffclk), .ffen(ffen), .ffas(ffas), .ffar(ffar), .ffq(qff));
  dff_latch latch_mode(.ffd(ffd), .ffclk(ffclk), .ffen(ffen), .ffas(ffas), .ffar(ffar), .ffq(qlatch));

  assign q = qff & storage_mux | qlatch & ~storage_mux;

  assign ffq = q;
  assign ffqn = ~q;
endmodule

module dff_latch(
  input ffd, ffclk, ffen, ffas, ffar,
  output reg ffq
);

  always @ (*) begin
    if (ffar == 1)
      ffq <= 0;

    else if (ffas == 1)
      ffq <= 1;

    else if (ffclk == 1 && ffen == 1)
      ffq <= ffd;

  end
endmodule

module dff_flipflop(
  input ffd, ffclk, ffen, ffas, ffar,
  output reg ffq
);

  always @ (posedge ffclk or posedge ffar or posedge ffas) begin
    if (ffar == 1)
      ffq <= 0;

    else if (ffas == 1)
      ffq <= 1;

    else if (ffclk == 1 && ffen == 1)
      ffq <= ffd;

  end
endmodule


module pt1pt2_section(
  input pt1_mux, pt2_mux, xor_a_mux, xor_b_mux, xor_inv_mux,
  input pt1_v, pt2_v,
  output y2_v, y1y2vcc_v, mc_flb_v, sti1_v, sti2_v
);

  wire y1, y2;
  dualmux pt1m(
    .msel(pt1_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt1_v),
    .q0(sti1_v),
    .q1(y1)
  );

  dualmux pt2m(
    .msel(pt2_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt2_v),
    .q0(sti2_v),
    .q1(y2)
  );

  wire y1y2vcc;
  pt1pt2_routing p1p2r(
    .xor_a_mux(xor_a_mux), .xor_b_mux(xor_b_mux), .xor_inv_mux(xor_inv_mux),
    .y1(y1), .y2(y2),
    .mc_flb(mc_flb_v), .y1y2vcc(y1y2vcc)
  );

  assign y2_v = y2;
endmodule


module pt3_section(
  input pt3_mux,
  input pt3_v, gclrgnd_v,
  output sti3_v, ffar_v
);

  wire ar;
  dualmux pt3m(
    .msel(pt3_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt3_v),
    .q0(sti3_v),
    .q1(ar)
  );

  pt3_routing p3r(
    .ar(ar), .gclrgnd(gclrgnd_v),
    .ffar(ffar_v)
  );
endmodule


module pt4_section(
  input pt4_mux, pt4_func_mux,
  input pt4_v, qclk_v,
  output sti4_v, ffen_v, ffclk_v
);

  wire ce;
  dualmux pt4m(
    .msel(pt4_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt4_v),
    .q0(sti4_v),
    .q1(ce)
  );

  pt4_routing p4r(
    .pt4_mux(pt4_mux), .pt4_func_mux(pt4_func_mux),
    .ce(ce), .gclk(qclk_v),
    .ffen(ffen_v), .ffclk(ffclk_v)
  );
endmodule

module pt5_section(
  input pt5_mux, pt5_func_mux,
  input pt5_v,
  output sti5_v, as_v, vcc_pt5_v
);

  wire as_oe;
  dualmux pt5m(
    .msel(pt5_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt5_v),
    .q0(sti5_v),
    .q1(as_oe)
  );

  pt5_routing p5r(
    .pt5_func_mux(pt5_func_mux),
    .as_oe(as_oe),
    .as(as_v), .vcc_pt5(vcc_pt5_v)
  );
endmodule

module prexor_section(
  input pt1_mux, pt2_mux, xor_a_mux, xor_b_mux, xor_inv_mux,
  input pt1_v, pt2_v, ffqn_v,
  output xtb_v, sti1_v, sti2_v, mc_flb_v, y2_v
);
  wire y1y2vcc;
  pt1pt2_section pt1pt2m(
    .pt1_mux(pt1_mux), .pt2_mux(pt2_mux), .xor_a_mux(xor_a_mux), .xor_b_mux(xor_b_mux), .xor_inv_mux(xor_inv_mux),
    .pt1_v(pt1_v), .pt2_v(pt2_v),
    .y2_v(y2_v), .y1y2vcc_v(y1y2vcc), .sti1_v(sti1_v), .sti2_v(sti2_v), .mc_flb_v(mc_flb_v)
  );

  xor_b_side xorb(
    .xor_b_mux(xor_b_mux),
    .y1y2vcc(y1y2vcc), .ffqn(ffqn_v),
    .xtb(xtb_v)
  );
endmodule

module xornest(
  input xor_inv_mux, o_mux, d_mux,
  input xta, xtb, y2, q,
  output ffd, out
);
  wire qnxor, qxor;
  assign qxor = xta ^ xtb;
  assign qnxor = ~qxor;

  wire y2q;

  // o_mux is also dfast_mux
  mux y2orq(
    .mux(o_mux),
    .a0(q),
    .a1(y2),
    .q(y2q)
  );

  wire inverted;
  mux invert(
    .mux(xor_inv_mux),
    .a0(qnxor),
    .a1(qxor),
    .q(inverted)
  );

  mux dffmux(
    .mux(d_mux),
    .a0(y2q),
    .a1(inverted),
    .q(ffd)
  );

  assign out = inverted;

endmodule

module sumpiece(
  input casin, sti1, sti2, sti3, sti4, sti5,
  output sum
);
  assign sum = casin | sti1 | sti2 | sti3 | sti4 | sti5;
endmodule

module pt1pt2_routing(
  input xor_a_mux, xor_b_mux, xor_inv_mux,
  input y1, y2,
  output mc_flb, y1y2vcc
);
  wire yf;

  assign yf = ~y1;

  wire flb_mux;
  assign flb_mux = xor_a_mux & ~xor_b_mux & xor_inv_mux;

  mux pt1f(
    .mux(flb_mux),
    .a0(yf),
    .a1(1'b0),
    .q(mc_flb)
  );

  wire y1y2;

  mux selecty1y2(
    .mux(xor_a_mux),
    .a0(y2),
    .a1(y1),
    .q(y1y2)
  );

  mux selecty1y2vcc(
    .mux(xor_inv_mux),
    .a0(yf),
    .a1(1'b1),
    .q(y1y2vcc)
  );
endmodule


module pt3_routing(
  input ar, gclrgnd,
  output ffar
);
  assign ffar = ar | gclrgnd;
endmodule

module pt4_routing(
  input pt4_mux, pt4_func_mux,
  input ce, gclk,
  output ffen, ffclk
);

  wire pt4clk, qclk;

  mux selectclk(
    .mux(pt4_mux),
    .a0(1'b1),
    .a1(ce),
    .q(pt4clk)
  );

  mux selectffclk(
    .mux(pt4_func_mux),
    .a0(gclk),
    .a1(qclk),
    .q(ffclk)
  );
  
  wire ce_mux;
  assign ce_mux = ~pt4_func_mux & pt4_mux;

  mux selectce(
    .mux(ce_mux),
    .a0(ce),
    .a1(1'b1),
    .q(ffen)
  );
endmodule

module pt5_routing(
  input pt5_func_mux,
  input as_oe,
  output as, vcc_pt5
);
  dualmux pt5func(
    .msel(pt5_func_mux),
    .q0default(1'b1),
    .q1default(1'b0),
    .signal(as_oe),
    .q0(vcc_pt5),
    .q1(as)
  );
endmodule

module xor_a_side(
  input xor_a_mux,
  input y2, sum,
  output xta, casout
);
  dualmux xora(
    .msel(xor_a_mux),
    .q0default(y2),
    .q1default(1'b0),
    .signal(sum),
    .q0(xta),
    .q1(casout)
  );
endmodule

module xor_b_side(
  input xor_b_mux,
  input y1y2vcc, ffqn,
  output xtb
);
  mux xorb(
    .mux(xor_b_mux),
    .a0(ffqn),
    .a1(y1y2vcc),
    .q(xtb)
  );

endmodule

module goeselector(
  input [0:2]oe_mux,
  input vcc_pt5,
  input [0:5]goe,
  output reg qoe
);
  always @ (*) begin
    casez(oe_mux)
      3'b000: qoe = 1'b0;
      3'b001: qoe = goe[0];
      3'b100: qoe = goe[1];
      3'b101: qoe = goe[2];
      3'b010: qoe = goe[3];
      3'b011: qoe = goe[4];
      3'b110: qoe = goe[5];
      3'b111: qoe = vcc_pt5;
      default: qoe = 1'b0;
    endcase;
  end
endmodule

module gclk_selector(
  input [0:1]gclk_mux,
  input [0:2]gclk,
  output reg qclk
);
  always @ (*) begin
    casez(gclk_mux)
      3'b11: qclk = gclk[0];
      3'b00: qclk = gclk[1];
      3'b10: qclk = gclk[2];
      default: qclk = 1'b0;
    endcase;
  end
endmodule

module gclr_selector(
  input gclr_mux,
  input gclr,
  output gclrgnd
);
  assign gclrgnd = gclr & ~gclr_mux; // | 1'b0 & gclr_mux;
endmodule
