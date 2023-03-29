`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module Selector(
input [3:0] sel,
input [15:0] N,
output [3:0] H
    );
wire t0,t1,t2,t3;
assign t3={sel[3]&~sel[2]&~sel[1]&~sel[0]};
assign t2={~sel[3]&sel[2]&~sel[1]&~sel[0]};
assign t1={~sel[3]&~sel[2]&sel[1]&~sel[0]};
assign t0={~sel[3]&~sel[2]&~sel[1]&sel[0]};
assign H={(N[15:12]&{4{t3}})|(N[11:8]&{4{t2}})|(N[7:4]&{4{t1}})|(N[3:0]&{4{t0}})};
endmodule
