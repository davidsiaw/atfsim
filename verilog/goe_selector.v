module goe_selector(
  input [0:2]oe_mux,
  input vcc_pt5,
  input [0:5]goe,
  output reg qoe
);
  always @ (*) begin
    casez(oe_mux)
      3'b000: qoe = 1'b0;
      3'b001: qoe = goe[0];
      3'b100: qoe = goe[1];
      3'b101: qoe = goe[2];
      3'b010: qoe = goe[3];
      3'b011: qoe = goe[4];
      3'b110: qoe = goe[5];
      3'b111: qoe = vcc_pt5;
      default: qoe = 1'b0;
    endcase;
  end
endmodule
