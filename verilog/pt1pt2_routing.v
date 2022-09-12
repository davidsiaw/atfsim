`include "mux.v"

module pt1pt2_routing(
  input xor_a_mux, xor_b_mux, xor_inv_mux,
  input y1, y2,
  output mc_flb, y1y2vcc
);
  wire yf;

  assign yf = ~y1;

  wire flb_mux;
  assign flb_mux = xor_a_mux & ~xor_b_mux & xor_inv_mux;

  mux pt1f(
    .isel(flb_mux),
    .a0(yf),
    .a1(1'b0),
    .q(mc_flb)
  );

  wire y1y2;

  mux selecty1y2(
    .isel(xor_a_mux),
    .a0(y2),
    .a1(y1),
    .q(y1y2)
  );

  mux selecty1y2vcc(
    .isel(xor_inv_mux),
    .a0(yf),
    .a1(1'b1),
    .q(y1y2vcc)
  );
endmodule
