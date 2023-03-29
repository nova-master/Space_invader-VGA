`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2023 02:55:58 PM
// Design Name: 
// Module Name: counterUD16L
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counterUD16L #(
parameter [15:0] INIT=16'b0
)(
input Up, Dw, LD, clk,
input [15:0] sw,
//input Din,
output [15:0] Q,
output up4,dw4
    );
    //parameter [15:0] INIT=16'b0;
wire u1,u2,u3,u4;
wire d1,d2,d3,d4;
wire up1,up2,up3;
wire dw1,dw2,dw3;

countUD4L #(.INIT(INIT[3:0]))count1 (.Up(Up),.Dw(Dw),.LD(LD),.sw(sw[3:0]),.clk(clk),.Q(Q[3:0]),.UTC(u1),.DTC(d1));
assign up1=u1&Up&~Dw;
assign dw1=d1&~Up&Dw;

countUD4L #(.INIT(INIT[7:4]))count2 (.Up(up1),.Dw(dw1),.LD(LD),.sw(sw[7:4]),.clk(clk),.Q(Q[7:4]),.UTC(u2),.DTC(d2));
assign up2=u2&u1&Up&~Dw;
assign dw2=d2&d1&~Up&Dw;

countUD4L #(.INIT(INIT[11:8]))count3 (.Up(up2),.Dw(dw2),.LD(LD),.sw(sw[11:8]),.clk(clk),.Q(Q[11:8]),.UTC(u3),.DTC(d3));
assign up3=u3&u2&u1&Up&~Dw;
assign dw3=d3&d2&d1&~Up&Dw;

countUD4L #(.INIT(INIT[15:12]))count4 (.Up(up3),.Dw(dw3),.LD(LD),.sw(sw[15:12]),.clk(clk),.Q(Q[15:12]),.UTC(u4),.DTC(d4));
assign up4=u4&u3&u2&u1&Up&~Dw;
assign dw4=d4&d3&d2&d1&~Up&Dw;
endmodule