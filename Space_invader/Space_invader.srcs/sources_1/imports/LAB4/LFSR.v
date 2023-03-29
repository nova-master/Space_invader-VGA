`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
module LFSR(
input clk, 
input CE,
output [3:0]rnd
    );
    

wire [7:0] Q; 
FDRE #(.INIT(1'b0)) Q0_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[0]~^Q[5]~^Q[6]~^Q[7]), .Q(Q[0]));
FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[0]), .Q(Q[1]));
FDRE #(.INIT(1'b0)) Q2_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[1]), .Q(Q[2]));
FDRE #(.INIT(1'b0)) Q3_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[2]), .Q(Q[3]));
FDRE #(.INIT(1'b0)) Q4_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[3]), .Q(Q[4]));
FDRE #(.INIT(1'b0)) Q5_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[4]), .Q(Q[5]));
FDRE #(.INIT(1'b0)) Q6_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[5]), .Q(Q[6]));
FDRE #(.INIT(1'b0)) Q7_FF (.C(clk), .R(1'b0), .CE(CE), .D(Q[6]), .Q(Q[7]));

assign rnd=Q[7:0];
endmodule

//module LFSR(
//input clk, 
//output [7:0]rng
//    );
    

//   wire [7:0] Q; 
//FDRE #(.INIT(1'b0)) Q0_FF (.C(clk), .CE(1'b1), .D(Q[1]), .Q(Q[0]));
//FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .CE(1'b1), .D(Q[2]), .Q(Q[1]));
//FDRE #(.INIT(1'b0)) Q2_FF (.C(clk), .CE(1'b1), .D(Q[3]), .Q(Q[2]));
//FDRE #(.INIT(1'b0)) Q3_FF (.C(clk), .CE(1'b1), .D(Q[4]), .Q(Q[3]));
//FDRE #(.INIT(1'b0)) Q4_FF (.C(clk), .CE(1'b1), .D(Q[5]), .Q(Q[4]));
//FDRE #(.INIT(1'b0)) Q5_FF (.C(clk), .CE(1'b1), .D(Q[6]), .Q(Q[5]));
//FDRE #(.INIT(1'b0)) Q6_FF (.C(clk), .CE(1'b1), .D(Q[7]), .Q(Q[6]));
//FDRE #(.INIT(1'b0)) Q7_FF (.C(clk), .CE(1'b1), .D(Q[6]~^Q[7]), .Q(Q[7]));

//assign rng=Q;
//endmodule