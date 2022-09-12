`include "dualmux.v"
`include "pt5_routing.v"

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
