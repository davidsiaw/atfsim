`include "components.v"

module outputpiece(
  input o_mux,
  input out, ffq, oe,
  output q
);

  // * todo * implement out mux and buffer

endmodule;

module dff(
  input storage_mux,
  input ffd, ffclk, ffen, ffas, ffar,
  output ffq, ffqn
);

  // * todo * implement ff

endmodule;

module xornest(
  input xor_inv_mux, o_mux, d_mux,
  input xta, xtb, y2, q,
  output ffd, out
);
  wire qxor;
  assign qxor = xta ^ xtb;
  assign qnxor = ~qxor;

  wire y2q;

  mux y2orq(
    .mux(o_mux),
    .a0(q),
    .a1(y2),
    .q(y2q)
  );

  wire inverted;
  mux invert(
    .mux(xor_inv_mux),
    .a0(qxor),
    .a1(qnxor),
    .q(inverted)
  );

  mux dffmux(
    .mux(d_mux),
    .a0(y2q),
    .a1(inverted),
    .q(ffd)
  );

endmodule;

module sumpiece(
  input casin, sti1, sti2, sti3, sti4, sti5,
  output sum
);
  assign sum = casin | sti1 | sti2 | sti3 | sti4 | sti5;
endmodule;

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
endmodule;


module pt3_routing(
  input ar, gclrgnd,
  output ffar
);
  assign ffar = ar | gclrgnd;
endmodule;

module pt4_routing(
  input pt4_mux, pt4_func_mux,
  input ce, gclk,
  output ffen, ffclk
);

  wire pt4clk;

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
endmodule;

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
endmodule;

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
endmodule;

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

endmodule;

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
endmodule;

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
endmodule;

module gclr_selector(
  input gclr_mux,
  input gclr,
  output gclrgnd
);
  assign gclrgnd = gclr & ~gclr_mux; // | 1'b0 & gclr_mux;
endmodule;
