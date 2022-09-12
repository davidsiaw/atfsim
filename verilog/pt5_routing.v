`include "dualmux.v"

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
