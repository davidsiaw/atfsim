module gclr_selector(
  input gclr_mux,
  input gclr,
  output gclrgnd
);
  assign gclrgnd = gclr & ~gclr_mux | 1'b0 & gclr_mux;
endmodule
