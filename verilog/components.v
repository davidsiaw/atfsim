
// a common component in the CPLD
// this module takes msel which chooses which direction
// to direct the signal, to q0 or q1, depending on the msel value (0 = signal -> q0)
// it only directs it on one of them, the other receives the q_default
module dualmux(input msel, input q0default, q1default, signal, output q0, q1);
  assign q0 = q0default &  msel | signal & ~msel;
  assign q1 = q1default & ~msel | signal &  msel;
endmodule

// choose one
module mux(input mux, input a0, a1, output q);
  assign q = a0 & ~mux | a1 & mux;
endmodule
