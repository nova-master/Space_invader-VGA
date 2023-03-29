`timescale 1ns / 1ps
module SMship(
    input clk,btnC,T1,T3,Tsmall,ground, alien_player,            // System clock         
    output reset_timer, loadtarget, showship, showalien, moveship, flashalien, increasescore
);
    wire [15:0] xin;
	wire [15:0] yin;
	wire idle;
	wire waiting;
	wire descent;
	wire land;
	wire alien;
	wire flash;
	wire loadnew;
	wire next_idle;
	wire next_waiting;
	wire next_descent;
	wire next_land;
	wire next_alien;
	wire next_flash;
	wire next_loadnew;
	wire Q[6:0];
	
	assign next_idle = idle & ~btnC;
	assign next_waiting = (idle & btnC)| (waiting & ~T1);
	assign next_descent = (waiting& T1)| (loadnew & Tsmall) | (descent & ~ground);
	assign next_land = (descent & ground) | (land & ~T1);
	assign next_alien = (land & T1) | (alien &(~T3 & ~alien_player));
	assign next_flash = (alien & alien_player) | (flash & ~T1);
	assign next_loadnew = (flash & T1) | (alien & T3)| (loadnew & ~Tsmall);
	// only enable clocks when you are not in the freeze state
 FDRE #(.INIT(1'b1)) Q0_FF (.C(clk), .CE(1'b1),.R(1'b0), .D(next_idle), .Q(idle));
 FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .CE(1'b1),.R(1'b0),.D(next_waiting), .Q(waiting));
 FDRE #(.INIT(1'b0)) Q2_FF (.C(clk), .CE(1'b1),.R(1'b0),.D(next_descent), .Q(descent));
 FDRE #(.INIT(1'b0)) Q3_FF (.C(clk), .CE(1'b1),.R(1'b0), .D(next_land), .Q(land));
 FDRE #(.INIT(1'b0)) Q4_FF (.C(clk), .CE(1'b1),.R(1'b0), .D(next_alien), .Q(alien));
 FDRE #(.INIT(1'b0)) Q5_FF (.C(clk), .CE(1'b1),.R(1'b0), .D(next_flash), .Q(flash));
 FDRE #(.INIT(1'b0)) Q6_FF (.C(clk), .CE(1'b1),.R(1'b0),.D(next_loadnew), .Q(loadnew));                                                     

assign reset_timer = (idle & btnC ) | (descent & ground) | (land & T1) | (alien & T3) | (flash & T1) | (alien & alien_player) ;
assign loadtarget = (loadnew) | (waiting & T1);
assign showship = (descent | land);
assign showalien = (descent) | (land) | (alien);
assign moveship = descent;
assign flashalien = flash;
assign increasescore = (alien & alien_player);

endmodule