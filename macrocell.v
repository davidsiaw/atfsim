`include "cellparts.v"

// conventions:
//
// every module - 
// - must have two input keywords: first is for mux values, second is for signal values.
// - must have at least one output
// - signals have _v suffix
// - mux values have _mux suffix
// - internals have no suffix
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

        output casout_v, pad_v, mc_flb_v, mc_fb_v
    );

  wire sti1, sti2;
  wire xtb, ffqn, y2;
  prexor_section prexor(
      .pt1_mux(pt1_mux), .pt2_mux(pt2_mux), .xor_a_mux(xor_a_mux), .xor_b_mux(xor_b_mux), .xor_inv_mux(xor_inv_mux),
      .pt1_v(pt1_v), .pt2_v(pt2_v), .ffqn_v(ffqn),
      .xtb_v(xtb), .sti1_v(sti1), .sti2_v(sti2), .y2_v(y2), .mc_flb_v(mc_flb_v)
  );

  wire xta, sum;
  // combine section
  xor_a_side xora(
    .xor_a_mux(xor_a_mux),
    .y2(y2), .sum(sum),
    .xta(xta), .casout(casout_v)
  );

  wire sti3;
  wire ffar, gclrgnd;
  pt3_section pt3m(
    .pt3_mux(pt3_mux),
    .pt3_v(pt3_v), .gclrgnd_v(gclrgnd),
    .sti3_v(sti3), .ffar_v(ffar)
  );

  wire sti4;
  wire ffen, ffclk, qclk;
  pt4_section pt4m(
    .pt4_mux(pt4_mux), .pt4_func_mux(pt4_func_mux),
    .pt4_v(pt4_v), .qclk_v(qclk),
    .sti4_v(sti4), .ffen_v(ffen), .ffclk_v(ffclk)
  );

  wire sti5;
  wire vcc_pt5, as;
  pt5_section pt5m(
    .pt5_mux(pt5_mux), .pt5_func_mux(pt5_func_mux),
    .pt5_v(pt5_v),
    .sti5_v(sti5), .as_v(as), .vcc_pt5_v(vcc_pt5)
  );


  sumpiece orsum(
    .casin(casin_v), .sti1(sti1), .sti2(sti2), .sti3(sti3), .sti4(sti4), .sti5(sti5),
    .sum(sum)
  );

  wire ffd, xorout, q;
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

  gclk_selector gclkselect(
    .gclk_mux(gclk_mux),
    .gclk(gclk_v),
    .qclk(qclk)
  );

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
    .out(xorout), .ffq(ffq), .oe(qoe),
    .q(pad_v)
  );
endmodule;
