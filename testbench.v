`include "atf1502.v"

module testbench;
  reg clk=0;
  always #1 clk = ~clk;  // Create clock with period=10

  reg sig=1'bz;
  always #5 sig = ~sig;

  // A testbench
  reg [1:0]in = 2'b00;

  reg [0:95]longin = ~96'd0;

  integer i;

  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench );

    #2 sig <= 0;

    #10 in <= 2'b01;
    #10 in <= 2'b10;
    #10 in <= 2'b11;
    #10 in <= 2'b00;
    #10 in <= 2'b01;
    #10 in <= 2'b10;
    #10 in <= 2'b11;
    #10 in <= 2'b00;

    for (i=0; i<96; i=i+1) begin
      #4
      longin <= ~96'd0;
      longin[i] <= 0;
    end

    $display ("Hello world! The current time is (%0d ps)", $time);
    #20 $finish;            // Quit the simulation
  end

  // testmuxes t1(clk, sig, in[0]);
  //testproductinput t2(clk, longin);


endmodule;

// Test that the product input modules work correctly
module testproductinput(input clk, input [0:95]longin);
  wire q;
  productinput pti(
    .ptbitmap_mux(longin),
    .mc_flb({16{clk}}),
    .uim_p({40{clk}}),
    .pt(q)
  );
endmodule;

// Test the mux and dualmux components
module testmuxes(input clk, sig, in);
  wire q0, q1, qmux;

  dualmux dmux( .msel(in), .q0default(1'b0), .q1default(1'b0), .signal(sig), .q0(q0), .q1(q1) );   // Sub-modules work too.

  mux m( .mux(in), .a0(sig), .a1(~sig), .q(qmux) );
endmodule;