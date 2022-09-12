`include "dualmux.v"

module xor_a_side(
  input xor_a_mux,
  input y2, sum,
  output xta, casout
);
  dualmux xora(
    .msel(xor_a_mux),
    .q0default(y2),
    .q1default(1'b0),
    .signal(sum),
    .q0(xta),
    .q1(casout)
  );
endmodule
