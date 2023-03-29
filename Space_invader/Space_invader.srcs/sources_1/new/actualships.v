`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//// feed inputs from state machine
// inputs : clk, moveship, loadtarget, xin, yin, freeze variable to freeze things,
// outputs: (alien and ship are similar to the character in top module. It is placed in the vga assignments to find out where the ships and aliens to show up)
//alien,ship, bottom (goes high when ship is on ground) 
module actualships(
 input clk,T1, T3, moveship, loadtarget,freeze,btnC,
 input [15:0] xin, yin,
output alien,ship,ground,alien_ground
    );
  wire pixel2;
  wire shipd;
  //assign shipd = ((fall + 16'd9)<=16'd399) & pixel2;
  wire [15:0]fall1,fall2,fall3,fall4,fall5,fall_alien_reg;
  wire botto1,botto2,botto3,botto4,botto5;
  wire shipdown1, bottom1;
  wire shipdown2, bottom2;
  wire shipdown3, bottom3;
  wire shipdown4, bottom4;
  wire shipdown5, bottom5;
  
  wire Q, Qn,Qn1,td;
  wire Q_t3,Qn_t3;
   wire [7:0]rnd;  wire [7:0]rnd2;  wire [7:0]rnd3;  wire [7:0]rnd4;  wire [7:0]rnd5;
  wire [4:0]rnd2_1;  wire [4:0]rnd2_2;  wire [4:0]rnd2_3;  wire [4:0]rnd2_4;  wire [4:0]rnd2_5;
  wire [15:0] rnd_mult_16,rnd_mult_16_Reg;
  
  assign ground = bottom1;
  assign shipdown1 = (((fall1 + 16'd9) < 16'd399) & pixel2) ;
  assign shipdown2 = (((fall2 + 16'd9) < 16'd399) & pixel2) ;
  assign shipdown3 = (((fall3 + 16'd9) < 16'd399) & pixel2) ;
  assign shipdown4 = (((fall4 + 16'd9) < 16'd399) & pixel2) ;
  assign shipdown5 = (((fall5 + 16'd9) < 16'd399) & pixel2) ;
  assign bottom1 = ((fall1 + 16'd9) >= 16'd399);
  assign bottom2 = ((fall2 + 16'd9) >= 16'd399);
  assign bottom3 = ((fall3 + 16'd9) >= 16'd399);
  assign bottom4 = ((fall4 + 16'd9) >= 16'd399);
  assign bottom5 = ((fall5 + 16'd9) >= 16'd399);
  assign pixel2 = ((xin == 16'd655) & (yin == 16'd489)) | ((xin == 16'd654) & (yin == 16'd488));
  assign botto1 = (bottom1 == 1) && (T3 == 1) ? 1 : 0;
  assign botto2 = (bottom2 == 1) && (T3 == 1) ? 1 : 0;
  assign botto3 = (bottom3 == 1) && (T3 == 1) ? 1 : 0;
  assign botto4 = (bottom4 == 1) && (T3 == 1) ? 1 : 0;
  assign botto5 = (bottom5 == 1) && (T3 == 1) ? 1 : 0;
  counterUD16L #(.INIT(16'd8)) countfallship1 (.clk(clk), .Up(shipdown1 & Q), .Dw(1'b0), .LD(botto1 ), .sw(16'd8), .Q(fall1));
  counterUD16L #(.INIT(16'd8)) countfallship2 (.clk(clk), .Up(shipdown3 & Q), .Dw(1'b0), .LD(botto2 ), .sw(16'd8), .Q(fall2));
  counterUD16L #(.INIT(16'd8)) countfallship3 (.clk(clk), .Up(shipdown3 & Q), .Dw(1'b0), .LD(botto3 ), .sw(16'd8), .Q(fall3));
  counterUD16L #(.INIT(16'd8)) countfallship4 (.clk(clk), .Up(shipdown4 & Q), .Dw(1'b0), .LD(botto4 ), .sw(16'd8), .Q(fall4));
  counterUD16L #(.INIT(16'd8)) countfallship5 (.clk(clk), .Up(td), .Dw(1'b0), .LD(botto5 ), .sw(16'd8), .Q(fall5));
  
   assign ship = (xin>=(16'd30+rnd)) &   (xin <=(16'd60+rnd+rnd2_1)) & (yin>=fall1) & (yin <= (fall1 + 16'd10))
               | (xin>=(16'd100+rnd2)) & (xin <=(16'd130+rnd2+rnd2_2)) & (yin>=fall2) & (yin <= (fall2 + 16'd10))
               | (xin>=(16'd200+rnd3)) & (xin <=(16'd230+rnd3+rnd2_3)) & (yin>=fall3) & (yin <= (fall3 + 16'd10))
               | (xin>=(16'd300+rnd4)) & (xin <=(16'd330+rnd4+rnd2_4)) & (yin>=fall4) & (yin <= (fall4 + 16'd10))
               | (xin>=(16'd400+rnd5)) & (xin <=(16'd430+rnd5+rnd2_5)) & (yin>=fall5) & (yin <= (fall5 + 16'd10))&Q;
   
   assign alien= (xin>=(16'd42+rnd))   & (xin <=(16'd50+rnd+rnd2_1))   & (yin>=fall1) & (yin <= (fall1 + 16'd8))
               | (xin>=(16'd112+rnd2)) & (xin <=(16'd120+rnd2+rnd2_2)) & (yin>=fall2) & (yin <= (fall2 + 16'd8))
               | (xin>=(16'd212+rnd3)) & (xin <=(16'd220+rnd3+rnd2_3)) & (yin>=fall3) & (yin <= (fall3  + 16'd8))
               | (xin>=(16'd312+rnd4)) & (xin <=(16'd320+rnd4+rnd2_4)) & (yin>=fall4) & (yin <= (fall4 + 16'd8))
               | (xin>=(16'd412+rnd5)) & (xin <=(16'd420+rnd5+rnd2_5)) & (yin>=fall5) & (yin <= (fall5 + 16'd8))&Q;
  
   assign Qn1 = shipdown3 & T3; // btnc pressed start and keep until ship reaches to bottom and wait for 1 sec
      FDRE #(.INIT(1'd0)) dela (.C(clk), .R(1'b0), .CE(1'd1), .D(Qn1), .Q(td));

   
   assign Qn = btnC | Q; // btnc pressed start and keep until ship reaches to bottom and wait for 1 sec
   FDRE #(.INIT(1'd0)) dontshow_btnC (.C(clk), .R(1'b0), .CE(1'd1), .D(Qn), .Q(Q));
   counterUD16L #(.INIT(16'd0)) keep_fallen_reg (.clk(clk), .Up(1'b0), .Dw(1'b0), .LD(botto1), .sw(fall1), .Q(fall_alien_reg));
   FDRE #(.INIT(1'd0)) delay_alien_gnd (.C(clk), .R(1'b0), .CE(1'd1), .D(Qn_t3), .Q(Q_t3));
   assign Qn_t3 = (bottom1&~T3) | (Q_t3&~bottom1&~T3);

   counterUD16L #(.INIT(16'd0)) keep_rand_pos_alien (.clk(clk), .Up(1'b0), .Dw(1'b0), .LD(botto1), .sw(rnd_mult_16), .Q(rnd_mult_16_Reg));

// LFSR for random X position
LFSR u_random_X(.clk(clk) , .CE(Q&botto1), .rnd(rnd));
assign rnd2 = rnd<<3 ;
assign rnd3 = rnd<<2 ;
assign rnd4 = rnd<<5 ;
assign rnd5 = rnd<<4 ;

assign rnd2_1=rnd[4:0];
assign rnd2_2=rnd[6:2];
assign rnd2_3=rnd[7:3];
assign rnd2_4=rnd[5:1];
assign rnd2_5=rnd[3:0];


endmodule
