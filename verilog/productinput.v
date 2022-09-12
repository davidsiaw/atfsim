
// The selection procedure here is simple
// it just chooses the input where it is 0 and 1 everywhere else
// the fitter needs to ground all inputs of unused AND gates
module productinput(
  input [0:95]ptbitmap_mux,
  input [0:15]mc_flb,
  input [0:39]uim_p,
  output pt
);

  wire [0:39]uim_n;
  assign uim_n = ~uim_p;

  wire [0:95]andinput;

  generate
    genvar i;

    for (i=0; i<16; i=i+1) begin : gen_flb
      mux flb_select(
        .mux(ptbitmap_mux[i]),
        .a0(mc_flb[i]),
        .a1(1'b1),
        .q(andinput[i])
      );
    end

    for (i=0; i<40; i=i+1) begin : gen_uim
      mux uim_p_select(
        .mux(ptbitmap_mux[16+i*2]),
        .a0(uim_p[i]),
        .a1(1'b1),
        .q(andinput[16+i*2])
      );

      mux uim_n_select(
        .mux(ptbitmap_mux[16+i*2+1]),
        .a0(uim_n[i]),
        .a1(1'b1),
        .q(andinput[16+i*2+1])
      );
    end
  endgenerate

  assign pt = &andinput;
endmodule
