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

  // macrocell mc[0:15]();
  //

endmodule
