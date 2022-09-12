module storage_flipflop(
  input ffd, ffclk, ffen, ffas, ffar,
  output reg ffq
);

  always @ (posedge ffclk or posedge ffar or posedge ffas) begin
    if (ffar == 1)
      ffq <= 0;

    else if (ffas == 1)
      ffq <= 1;

    else if (ffclk == 1 && ffen == 1)
      ffq <= ffd;

  end
endmodule
