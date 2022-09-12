`ifndef MUX_V
`define MUX_V

// choose one
module mux(input isel, input a0, a1, output q);
  assign q = a0 & ~isel | a1 & isel;
endmodule

`endif // MUX_V
