`include "mux.v"

// combination of output selector and tristate buffer
module outputpiece(
  input o_mux,
  input out, ffq, oe,
  output q
);

  wire output_wire;

  mux outmux(
    .isel(o_mux),
    .a0(ffq),
    .a1(out),
    .q(output_wire)
  );

  mux tristate(
    .isel(oe),
    .a0(1'bz),
    .a1(output_wire),
    .q(q)
  );
endmodule
