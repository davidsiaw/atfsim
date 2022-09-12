`include "cellcore.v"
`include "productinput.v"

// The Macrocell here is defined as the cellcore + the product
// input modules that give the macrocell its product terms.

// this is the same definition as that given by the datasheet
// the distinction between its core and product terms is made
// here to make the code easier to understand

module macrocell(
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

  cellcore mc(
    pt1_mux, pt2_mux, pt3_mux, pt4_mux, pt5_mux,
    gclr_mux, pt4_func_mux, pt5_func_mux, xor_a_mux, xor_b_mux,
    xor_inv_mux, d_mux, storage_mux, fb_mux, o_mux,
    oe_mux,
    gclk_mux,

    pt[0], pt[1], pt[2], pt[3], pt[4],
    casin,
    gclr, goe, gclk,

    casout, pad, inv_mc_flb, mc_fb
  );

  assign mc_flb = ~inv_mc_flb;
endmodule
