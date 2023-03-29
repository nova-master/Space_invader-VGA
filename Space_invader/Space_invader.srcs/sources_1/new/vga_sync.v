`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module vga_sync	(
		input clk, reset,
		output  hsync, vsync,
		output [15:0] x, y,
		output  frame
	);
	
	wire hreset;
	wire vreset;
	assign hreset = x == 16'd799;
	assign vreset = hreset & (y == 16'd524);
	counterUD16L horizontal (.clk(clk), .Up(1'b1), .Dw(1'b0), .LD(hreset), .sw({16{1'b0}}), .Q(x));
	counterUD16L vertical (.clk(clk), .Up(hreset), .Dw(1'b0), .LD(vreset), .sw({16{1'b0}}), .Q(y));
	
	
        wire hsynctemp; 
        wire vsynctemp;
        //assign hsynctemp  = (x <= 16'd656) || (x>=16'd751);
        //assign vsynctemp  = (y <= 16'd513) || (y>=16'd514);
        assign hsynctemp  = (x < 16'd655) || (x>16'd750);
       assign vsynctemp  =  (y < 16'd489) || (y>16'd490);
        FDRE #(.INIT(1'b1)) ff_0 (.C(clk), .R(1'b0), .CE(1'b1), .D(hsynctemp), .Q(hsync));
        FDRE #(.INIT(1'b1)) ff_1 (.C(clk), .R(1'b0), .CE(1'b1), .D(vsynctemp), .Q(vsync));
        
        
        FDRE #(.INIT(1'b1)) ff_2 (.C(clk), .R(1'b0), .CE(1'b1), .D((x == 16'd799) & (y == 16'd524)), .Q(frame));
endmodule
