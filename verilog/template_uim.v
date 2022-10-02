// Template for UIM switch
module template_uim(
  input [4:0]uim_mux,
  input input_31, input_30, input_29, input_27, input_23, input_15,
  output reg q
);
  always @ (*) begin
    casez(uim_mux)
      5'b0zzzz: q = input_15;
      5'bz0zzz: q = input_23;
      5'bzz0zz: q = input_27;
      5'bzzz0z: q = input_29;
      5'bzzzz0: q = input_30;
       default: q = input_31;
    endcase;
  end
endmodule
