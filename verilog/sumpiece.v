module sumpiece(
  input casin, sti1, sti2, sti3, sti4, sti5,
  output sum
);
  assign sum = casin | sti1 | sti2 | sti3 | sti4 | sti5;
endmodule
