`include "cellparts.v"

// conventions:
//
// every module - 
// - must have two input keywords: first is for mux values, second is for signal values.
// - must have at least one output
// - signals have _v suffix
// - mux values have _mux suffix
// - common design patters should be refactored into a module

module macrocell(
        input pt1_mux, pt2_mux, pt3_mux, pt4_mux, pt5_mux,
              gclr_mux, pt4_func_mux, pt5_func_mux, xor_a_mux, xor_b_mux,
              xor_inv_mux, d_mux, dfast_mux, storage_mux, fb_mux, o_mux,
        input [0:2]oe_mux,
        input [0:1]gclk_mux,

        input pt1_v, pt2_v, pt3_v, pt4_v, pt5_v,
              casin_v, gclr_v,
        input [0:5]goe_v,
        input [0:2]gclk_v,

        output wire casout, pad, mc_flb, mc_fb
    );

  wire y1, y2;
  wire ar;
  wire ce;
  wire as_oe;

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

  dualmux pt3m(
    .msel(pt3_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt3_v),
    .q0(sti3_v),
    .q1(ar)
  );

  dualmux pt4m(
    .msel(pt4_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt4_v),
    .q0(sti4_v),
    .q1(ce)
  );

  dualmux pt5m(
    .msel(pt5_mux),
    .q0default(1'b0),
    .q1default(1'b0),
    .signal(pt5_v),
    .q0(sti5_v),
    .q1(as_oe)
  );

  // function section
  wire y1y2vcc;
  pt1pt2_routing p1p2r(
    .xor_a_mux(xor_a_mux), .xor_b_mux(xor_b_mux), .xor_inv_mux(xor_inv_mux),
    .y1(y1), .y2(y2),
    .mc_flb(mc_flb), .y1y2vcc(y1y2vcc)
  );

  wire ffar;
  pt3_routing p3r(
    .ar(ar), .gclrgnd(gclrgnd),
    .ffar(ffar)
  );

  wire ffen, ffclk;
  pt4_routing p4r(
    .pt4_mux(pt4_mux), .pt4_func_mux(pt4_func_mux),
    .ce(ce), .gclk(qclk),
    .ffen(ffen), .ffclk(ffclk)
  );

  wire vcc_pt5, as;
  pt5_routing p5r(
    .pt5_func_mux(pt5_func_mux),
    .as_oe(as_oe),
    .as(as), .vcc_pt5(vcc_pt5)
  );

  wire xta, xtb;

  xor_a_side xora(
    .xor_a_mux(xor_a_mux),
    .y2(y2), .sum(sum),
    .xta(xta), .casout(casout)
  );

  xor_b_side xorb(
    .xor_b_mux(xor_b_mux),
    .y1y2vcc(y1y2vcc), .ffqn(ffqn),
    .xtb(xtb)
  );

  // combine section
  wire sum;
  sumpiece orsum(
    .casin(casin_v), .sti1(sti1), .sti2(sti2), .sti3(sti3), .sti4(sti4), .sti5(sti5),
    .sum(sum)
  );

  wire ffd, xorout;
  xornest xors(
    .xor_inv_mux(xor_inv_mux), .o_mux(o_mux), .d_mux(d_mux),
    .xta(xta), .xtb(xtb), .y2(y2), .q(q),
    .ffd(ffd), .out(xorout)
  );


  // globin section
  wire qoe;
  goeselector goeselect(
    .oe_mux(oe_mux),
    .goe(goe_v), .vcc_pt5(vcc_pt5),
    .qoe(qoe)
  );

  wire qclk;
  gclk_selector gclkselect(
    .gclk_mux(gclk_mux),
    .gclk(gclk_v),
    .qclk(qclk)
  );

  wire gclrgnd;
  gclr_selector gclrselect(
    .gclr_mux(gclr_mux),
    .gclr(gclr_v),
    .gclrgnd(gclrgnd)
  );

  // output section
  wire ffq;

  dff storage(
    .storage_mux(storage_mux),
    .ffd(ffd), .ffclk(ffclk), .ffen(ffen), .ffas(as), .ffar(ffar),
    .ffq(ffq), .ffqn(ffqn)
  );

  outputpiece outputter(
    .o_mux(o_mux),
    .out(xorout), .ffq(ffq), .oe(oe),
    .q(pad)
  );
endmodule;
