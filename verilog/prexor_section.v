`include "mux.v"

module prexor_section(
  input xor_b_mux,
  input y1y2vcc, ffqn,
  output xtb
);
  mux prexor(
    .isel(xor_b_mux),
    .a0(ffqn),
    .a1(y1y2vcc),
    .q(xtb)
  );

endmodule
