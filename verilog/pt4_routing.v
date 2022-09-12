`include "mux.v"

module pt4_routing(
  input pt4_mux, pt4_func_mux,
  input ce, gclk,
  output ffen, ffclk
);

  wire pt4clk, qclk;

  mux selectclk(
    .isel(pt4_mux),
    .a0(1'b1),
    .a1(ce),
    .q(pt4clk)
  );

  mux selectffclk(
    .isel(pt4_func_mux),
    .a0(gclk),
    .a1(qclk),
    .q(ffclk)
  );
  
  wire ce_mux;
  assign ce_mux = ~pt4_func_mux & pt4_mux;

  mux selectce(
    .isel(ce_mux),
    .a0(ce),
    .a1(1'b1),
    .q(ffen)
  );
endmodule
