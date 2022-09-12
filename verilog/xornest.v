`include "mux.v"

module xornest(
  input xor_inv_mux, o_mux, d_mux,
  input xta, xtb, y2, q,
  output ffd, out
);
  wire qnxor, qxor;
  assign qxor = xta ^ xtb;
  assign qnxor = ~qxor;

  wire y2q;

  // o_mux is also dfast_mux
  mux y2orq(
    .isel(o_mux),
    .a0(q),
    .a1(y2),
    .q(y2q)
  );

  wire inverted;
  mux invert(
    .isel(xor_inv_mux),
    .a0(qnxor),
    .a1(qxor),
    .q(inverted)
  );

  mux dffmux(
    .isel(d_mux),
    .a0(y2q),
    .a1(inverted),
    .q(ffd)
  );

  assign out = inverted;

endmodule
