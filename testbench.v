`include "atf1502.v"

module testbench;
  reg clk=0;
  always #5 clk = ~clk;  // Create clock with period=10

  reg sig=1'bz;
  always #1 sig = ~sig;

  // A testbench
  reg in=0;
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench );

    #2 sig <= 0;

    #10 in <= 1;
    #10 in <= 0;
    #20 in <= 1;
    #20 in <= 0;
    $display ("Hello world! The current time is (%0d ps)", $time);
    #50 $finish;            // Quit the simulation
  end

  wire q0, q1;

  dualmux dmux( .msel(in), .q0default(1'b0), .q1default(1'b0), .signal(sig), .q0(q0), .q1(q1) );   // Sub-modules work too.

endmodule;
