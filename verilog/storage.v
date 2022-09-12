`include "storage_latch.v"
`include "storage_flipflop.v"

// the macrocell storage element
module storage(
  input storage_mux,
  input ffd, ffclk, ffen, ffas, ffar,
  output ffq, ffqn
);
  
  wire qlatch, qff, q;

  // yosys doesn't let us trigger on both en and clk so
  // we just make both kinds of storage and choose one to use
  storage_flipflop ff_mode(.ffd(ffd), .ffclk(ffclk), .ffen(ffen), .ffas(ffas), .ffar(ffar), .ffq(qff));
  storage_latch latch_mode(.ffd(ffd), .ffclk(ffclk), .ffen(ffen), .ffas(ffas), .ffar(ffar), .ffq(qlatch));

  assign q = qff & storage_mux | qlatch & ~storage_mux;

  assign ffq = q;
  assign ffqn = ~q;
endmodule
