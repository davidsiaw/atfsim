`include "pt1pt2_section.v"
`include "prexor_section.v"

module xor_b_side(
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

  prexor_section xorb(
    .xor_b_mux(xor_b_mux),
    .y1y2vcc(y1y2vcc), .ffqn(ffqn_v),
    .xtb(xtb_v)
  );
endmodule
