`include "dualmux.v"
`include "pt3_routing.v"

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
