module pt3_routing(
  input ar, gclrgnd,
  output ffar
);
  assign ffar = ar | gclrgnd;
endmodule
