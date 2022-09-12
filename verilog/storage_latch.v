module storage_latch(
  input ffd, ffclk, ffen, ffas, ffar,
  output reg ffq
);

  always @ (*) begin
    if (ffar == 1)
      ffq <= 0;

    else if (ffas == 1)
      ffq <= 1;

    else if (ffclk == 1 && ffen == 1)
      ffq <= ffd;

  end
endmodule
