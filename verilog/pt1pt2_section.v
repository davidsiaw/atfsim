`include "dualmux.v"
`include "pt1pt2_routing.v"

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
