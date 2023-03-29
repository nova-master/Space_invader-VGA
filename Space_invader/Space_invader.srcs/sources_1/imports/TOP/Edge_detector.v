`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2023 10:18:32 AM
// Design Name: 
// Module Name: Edge_detector
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


module Edge_detector(
    input X, clk, //X{0}=btnU and //X{1}=btnD
    output Y
);


 wire q0;
    FDRE #(.INIT(1'b0)) Bit1 (.C(clk), .R(1'b0), .CE(1'b1), .D(X), .Q(q0));
    //FDRE #(.INIT(1'b0)) Bit2 (.C(clk), .R(1'b0), .CE(1'b1), .D(X[1]), .Q(q1));
    
   
    //https://electronics.stackexchange.com/questions/165552/rising-edge-pulse-detector-from-logic-gates
    assign Y=( X & ~q0);   //this is going to detect rising/positive edge of this btnU signal
endmodule