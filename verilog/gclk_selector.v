module gclk_selector(
  input [0:1]gclk_mux,
  input [0:2]gclk,
  output reg qclk
);
  always @ (*) begin
    casez(gclk_mux)
      3'b11: qclk = gclk[0];
      3'b00: qclk = gclk[1];
      3'b10: qclk = gclk[2];
      default: qclk = 1'b0;
    endcase;
  end
endmodule
