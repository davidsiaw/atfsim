`include "macrocell.v"

// notes
// might have to generate this for each device from som template, but
// not needed right now

module atf1502(
  input [0:45]global_mux,
  inout[0:40]pins
);

  wire [0:31]pad;
  wire [0:31]mc_fb;
  wire [0:79]uim;

  wire [0:2]gclk;
  wire [0:5]goe;
  wire gclr;

  // todo

  // switchbox swa(pad, mc_fb, uim[0:39]);
  // switchbox swb(pad, mc_fb, uim[40:79]);

  // logic_block lba();
  // logic_block lbb();


endmodule

module globalswitch(
  input [0:45]global_mux,
  input [0:40]pins,
  output [0:2]gclk,
  output [0:5]goe,
  output gclr
);

  // todo 
endmodule

module switchbox(
  input [0:31]pad,
  input [0:31]mc_fb,
  output [0:39]uim
);

endmodule

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

// This is basically the macrocell + the product input modules that
// give the macrocell its product terms.
module macrogroup(
  input [0:2]oe_mux,
  input [0:1]gclk_mux,
  input [0:479]ptgroupbitmap_mux,

  input pt1_mux, pt2_mux, pt3_mux, pt4_mux, pt5_mux,
        gclr_mux, pt4_func_mux, pt5_func_mux, xor_a_mux, xor_b_mux,
        xor_inv_mux, d_mux, dfast_mux, storage_mux, fb_mux, o_mux,

  input [0:39]uim,
  input [0:15]in_flb,
  input [0:5]goe,
  input [0:2]gclk,
  input casin,
  input gclr,
  output pad,
  output mc_fb,
  output casout,
  output mc_flb
);

  wire [0:4]pt;

  generate
    genvar i;
    for (i=0; i<5; i=i+1) begin : gen_pti
      productinput pti(
        .ptbitmap_mux(ptgroupbitmap_mux[i*96:i*96+95]),
        .uim_p(uim),
        .mc_flb(in_flb),
        .pt(pt[i])
      );
    end
  endgenerate;

  wire inv_mc_flb;

  macrocell mc(
    pt1_mux, pt2_mux, pt3_mux, pt4_mux, pt5_mux,
    gclr_mux, pt4_func_mux, pt5_func_mux, xor_a_mux, xor_b_mux,
    xor_inv_mux, d_mux, dfast_mux, storage_mux, fb_mux, o_mux,
    oe_mux,
    gclk_mux,

    pt[0], pt[1], pt[2], pt[3], pt[4],
    casin,
    gclr, goe, gclk,

    casout, pad, inv_mc_flb, mc_fb
  );

  assign mc_flb = ~inv_mc_flb;
endmodule

module logic_block(
  input [0:65000]logicgroupbitmap_mux,

  input [0:39]uim,
  input [0:5]goe,
  input [0:2]gclk,
  input gclr,
  output [0:15]pad,
  output [0:15]mc_fb
);

  // todo

  // write a script to program the mux bitmap mappings

  wire [0:15]mc_flb;

  // macrogroup mc[0:15]();
  //

endmodule
