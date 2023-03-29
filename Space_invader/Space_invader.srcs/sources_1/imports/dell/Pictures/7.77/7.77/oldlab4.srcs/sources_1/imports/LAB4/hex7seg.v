`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Compan
//////////////////////////////////////////////////////////////////////////////////
module hex7seg(
    input[3:0] i,
    output  [6:0]seg
    );
 wire i0,i1,i2,i3;
    assign i3 = i[3];
    assign i2 = i[2];
    assign i1 = i[1];
    assign i0 = i[0];

assign seg[0] = (~i3 & ~i2 & ~i1 & i0) | (~i3 & i2 & ~i1 & ~i0) | (i3 & ~i2 & i1 & i0) | (i3 & i2 & ~i1 & i0);
assign seg[1] = (~i3 & i2 & ~i1 & i0) | (~i3 & i2 & i1 & ~i0) | (i3 & ~i2 & i1 & i0) | (i3 & i2 & ~i1 & ~i0) | (i3 & i2 & i1 & ~i0) | (i3 & i2 & i1 & i0);
assign seg[2] = (~i3 & ~i2 & i1 & ~i0) | (i3 & i2 & ~i1 & ~i0) | (i3 & i2 & i1 & ~i0) | (i3 & i2 & i1 & i0);
assign seg[3] = (~i3 & ~i2 & ~i1 & i0) | (~i3 & i2 & ~i1 & ~i0) | (~i3 & i2 & i1 & i0) | (i3 & ~i2 & ~i1 & i0) + (i3 & ~i2 & i1 & ~i0) + (i3 & i2 & i1 & i0);
assign seg[4] = (~i3 & ~i2 & ~i1 & i0) | (~i3 & ~i2 & i1 & i0) | (~i3 & i2 & ~i1 & ~i0) | (~i3 & i2 & ~i1 & i0) + (~i3 & i2 & i1 & i0) | (i3 & ~i2 & ~i1 & i0);
assign seg[5] = (~i3 & ~i2 & ~i1 & i0) | (~i3 & ~i2 & i1 & ~i0) | (~i3 & ~i2 & i1 & i0) | (~i3 & i2 & i1 & i0) + (i3 & i2 & ~i1 & i0);
assign seg[6] = (~i3 & ~i2 & ~i1 & ~i0) | (~i3 & ~i2 & ~i1 & i0) | (~i3 & i2 & i1 & i0) | (i3 & i2 & ~i1 & ~i0);

endmodule






