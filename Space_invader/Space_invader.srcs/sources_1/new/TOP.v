`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////
module TOP
	(
		input clkin, btnU,btnD,btnL,btnR,btnC,
		input [15:0] sw,
		output hsync, vsync,
		output [11:0] rgb,
		output [3:0]an,
		output dp, 
		output [6:0]seg,
		output [15:0]led
	); 
	   wire qsec,digsel,s,p,clkslow,clk;
	   //wire [15:0] sw;
	   labVGA_clks not_so_slow (.clkin(clkin), .greset(btnU), .clk(clk), .digsel(digsel));                           
    wire [15:0] xin;
	wire [15:0] yin;
    wire vi;
    FDRE #(.INIT(1'b1) ) Active_sync (.C(clk), .CE(1'b1), .D((yin < 16'd480) & (xin < 16'd640)), .Q(vi), .R(1'b0));
     //qsec_clks slowit (.clkin(p), .greset(btnD), .clk(s), .digsel(digsel), .qsec(qsec));
	// register for Basys 2 8-bit RGB DAC 
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
	wire reset;
	
wire d;
wire frame;
        // instantiate vga_sync
        vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .x(xin), .y(yin), .frame(frame));
                             
  wire border;
  assign border =    ((xin >= 16'd0) & (xin <= 16'd7) & (yin >= 16'd0) & (yin <= 16'd479)) //left
                    | ((xin >= 16'd632) & (xin <= 16'd639) & (yin >= 16'd0) & (yin <= 16'd479)) //r
                    | ((xin >= 16'd0) & (xin <= 16'd639) & (yin >= 16'd0) & (yin <= 16'd7)) //up
                    | ((xin >= 16'd0) & (xin <= 16'd639) & (yin >= 16'd472) & (yin <= 16'd479)); //b                              
  
      wire [3:0]vgaRed;  
      wire [3:0]vgaGreen;  
      wire [3:0]vgaBlue; 
      wire grass,ground,character;
      wire i;
      wire [15:0] playerh, playerv;
      wire playerup;

wire playerdown;
wire playerleft;
wire playeright;
wire btnRR,btnLL;
//Edge_detector edg1 (.X(btnR), .clk(clk), .Y(btnRR)) ;
//Edge_detector edg2 (.X(btnL), .clk(clk), .Y(btnLL)) ;
//Clock_divider divider (.clkold(clk), .clk(clkslow));

///when i tried to give the input to the .up() of counter then it does not get any signal from moveship ,then i hardcoded it with 1
//but this make ship moving so fast and i can only see some dots, then i assign this up = btnR using edge detector,not ship is moving correcr when btnR is pressed'
//now i am trying to feed this Dw() whih slow clock to see its  movement without btn . but clock is still very fast;
      
      wire [15:0]timecounter1;
      Time_Counter tc1 (.Inc(frame), .R(reset_timer1), .clk(clk), .CE(1'b1), .Q(timecounter1));
      wire t11, t31, tsmall1, t11temp, t31temp, ground1, reset_timer1, loadtarget1, showship1, showalien1, moveship1, flashalien1, increasescore1, ship1, ground1, alien1;
      
      
      SMship shipone (.clk(clk), .btnC(btnC), .T1(t11), .T3(t31), .Tsmall(tsmall1), .ground(ground1), 
.alien_player(1'b0), .reset_timer(reset_timer1), .loadtarget(loadtarget1),
 .showship(showship1), .showalien(showalien1), .moveship(moveship1), .flashalien(flashalien1), .increasescore(increasescore1));
 
 actualships fallship1 (.clk(clk),.T1(t11),.T3(t31), .moveship(moveship1), .loadtarget(loadtarget1), .xin(xin), .yin(yin), .freeze(freeze),
.alien(alien1),.ship(ship1), .ground(ground1), .alien_ground(alien_ground1) , .btnC(btnC));
 
       assign t11 = (timecounter1 == 16'd60);
      assign t31 = (timecounter1 == 16'd180);
      assign tsmall1 = (timecounter1 == 16'd2);
 
  counterUD16L #(.INIT(16'd384)) countfallship (.clk(clk), .Up(T3), .Dw(1'b0), .LD(1'b0), .sw({4{1'b0}}), .Q(fall));
    //assign ship = (xin>=16'd10) & (xin <=(16'd60)) & (yin>=fall) & (yin <= (fall + 16'd15));
      assign ground = xin >= 16'd8 & xin <= 16'd631 & yin >= 16'd412 & yin <= 16'd471;
    assign grass = xin >= 16'd8 & xin <= 16'd631 & yin >= 16'd406 & yin <= 16'd411;
    assign character = (xin>=playerh) & (xin <=(playerh+16'd15)) & (yin>=playerv) & (yin <= (playerv + 16'd15));
 
        // assign ship =  (xin>=fall) & (xin <=(fall+16'd85)) & (yin>=fall) & (yin <= (fall + 16'd15));

    assign vgaRed = ({4{vi}} & {4{border}} & {4'b1111}) | ({4{vi}} & {4{ground}} & {4'b0111} & ~{4{border}}) 
                     | ({4{vi}} & {4{character}} & {4'b1111}) | ({4{vi}} & {4{alien1}} & {4'b1111} & {4{showalien1}}); //| ({4{vi}} & {4{alien_ground1}} & {4'b1111} & ~{4{ground}});
    assign vgaBlue = ({4{vi}} & {4{ground}} & {4'b0100}) | ({4{vi}} & {4{ship1}} & {4'b1111} & {4{showship1}});
    assign vgaGreen = ({4{vi}} & {4{grass}} & {4'b1111}) | ({4{vi}} & {4{ground}} & {4'b0100})
                    | ({4{vi}} & {4{character}} & {4'b1111});
//  assign vgaRed = ({4{vi}} & {4{border}} & {4'b1111}) | ({4{vi}} & {4{ground}} & {4'b0111} & ~{4{border}}) 
//                     | ({4{vi}} & {4{character}} & {4'b1111});
//    assign vgaBlue = ({4{vi}} & {4{ground}} & {4'b0100});
//    assign vgaGreen = ({4{vi}} & {4{grass}} & {4'b1111}) | ({4{vi}} & {4{ground}} & {4'b0100})
//                    | ({4{vi}} & {4{character}} & {4'b1111});
  
        assign rgb[11:8] = vgaRed;        //assign rgb = (video_on) ? vgaRed : 12'h0f0;
        assign rgb[7:4] = vgaGreen;        //assign rgb = (video_on) ? vgaRed : 12'h0f0;
        assign rgb[3:0] = vgaBlue;        //assign rgb = (video_on) ? vgaRed : 12'h0f0;
        
     
//wire  moveship, loadtarget,  freeze,  T1, T3;
counterUD16L #(.INIT(16'd320)) countLR (.clk(clk), .Up(playeright), .Dw(playerleft), .LD(1'b0), .sw({4{1'b0}}), .Q(playerh));
counterUD16L #(.INIT(16'd384)) countUD (.clk(clk), .Up(playerdown), .Dw(playerup), .LD(1'b0), .sw({4{1'b0}}), .Q(playerv));
 
wire pixel;

assign pixel = (xin == 16'd640) & (yin == 16'd520);
assign playerup= ((~btnR & ~btnD & ~btnL) & ((playerv) >  16'd384)) & pixel ;
assign playerdown=((~btnL & ~btnR & btnD & ~btnU) & ((playerv + 16'd15) < 16'd471)) & pixel ;
assign playerleft=((btnL & ~btnR & ~btnD & ~btnU) & ((playerh) > 16'd8))&(playerv == 16'd384) & pixel;
assign playeright=((~btnL & btnR & ~btnD & ~btnU) & ((playerh + 16'd15) < 16'd631))&(playerv == 16'd384) & pixel;

wire [15:0] score_reg;
wire score,score_pos;
wire game_over;
   wire bot;
                                             //   assign bot = ((yin) >= 16'd399);

                                // assign game_over = character & ship1& bot;
                                // assign  score = character & alien1 ;
                                 
parameter char_x = 16'd15;
parameter char_y = 16'd15 ;
parameter char_width = 16'd15;
parameter char_height = 16'd15;

parameter alien_x = 16'd0;
parameter alien_y = 16'd8;
parameter alien_width = 16'd15;
parameter alien_height = 16'd15;

// Use assign statements to check for overlap
assign x_overlap = ((char_x + char_width) >= alien_x) && (char_x <= (alien_x + alien_width));
assign y_overlap = ((char_y + char_height) >= alien_y) && (char_y <= (alien_y + alien_height));
assign collision = x_overlap && y_overlap;
                                 
Edge_detector (.clk(clk), .X(score), .Y(score_pos));
counterUD16L #(.INIT(16'd0)) score_brd (.clk(clk), .Up(score_pos), .Dw(1'b0), .LD(1'b0), .sw('d0), .Q(score_reg));

wire [3:0] RingOut;  wire [6:0] hexOut;     wire [17:0]register1;reg x;
RingCounter ring (.clk(clk), .digsel(digsel),  .q(RingOut));
wire [3:0]selectOut;
//Selector select (.sel(RingOut), .N({score_reg[3:0], 4'b0, 4'b0, score_reg[3:0]}), .H(selectOut));
Selector select (.sel(RingOut), .N(score_reg), .H(selectOut));
hex7seg display1 (.i(selectOut),.seg(hexOut));
 
  assign an[3] = ~RingOut[3];
  assign an[2] = ~RingOut[2];
  assign an[1] = ~RingOut[1];
  assign an[0] = ~RingOut[0];
 
  assign seg=hexOut;
  //assign led[3:0]=selectOut;
  //assign led[15:9]=hexOut;
  assign led[6]=character;
  assign led[15]=score;
  
  assign led[7]=alien1;
  endmodule
