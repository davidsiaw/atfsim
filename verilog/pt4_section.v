`include "dualmux.v"
`include "pt4_routing.v"

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
