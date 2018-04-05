`timescale 1ns / 1ns // `timescale time_unit/time_precision
module pbs(SW, LEDR, LEDG, CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	input [17:0] SW;
	output [17:0] LEDR;
	output [8:0]  LEDG;
	input [8:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;
	
	wire [3:0] p_hp_wire;
	wire [3:0] ai_hp_wire;
	wire ai_dead_wire;
	wire p_dead_wire;
	wire [3:0] curr_ai_hp_wire;
	wire clk;
	assign clk = ~KEY[1];
//	wire go;
//	assign go = SW[17];
	
	wire rst;
	assign rst = SW[12];
	
	wire target_wire;
	wire actr_wire;
	wire load_ai_hp_wire;
	wire apply_p_dmg_wire;
	wire apply_ai_dmg_wire;
	wire [3:0] moveaccurng_wire;
	wire p_heal_wire;
	wire catch_success_wire;
	wire catch_wire;
	wire cacatch_fail_led_wire;
	wire caught_led_wire;
	
	wire [7:0] move_disp_wire;
	
	pbs_dp dp (
	
	           .target(target_wire),
				  .heal(p_heal_wire),
				  .catch(catch_wire),
				  .stop(1'b1),
				  .p_move(SW[3:2]),
				  .actr(actr_wire),
				  .load_ai_hp(load_ai_hp_wire),
				  .app_pl_dmg(apply_p_dmg_wire),
				  .app_ai_dmg(apply_ai_dmg_wire),
				  .clk(clk),
				  .rst(rst),
				  .p_hp(p_hp_wire),
				  .AI_hp(ai_hp_wire),
				  .dmg(move_disp_wire[3:0]),
              .accu(move_disp_wire[7:4]),
				  .ai_dead(ai_dead_wire),
				  .p_dead(p_dead_wire),
				  .moveaccurng(moveaccurng_wire),
				  .catch_success(catch_success_wire)
				  );
   
	control fsm (
       .clk(clk),
       .reset_n(rst),
       .go(go),
       .p_hp(p_hp_wire),
       .ai_dead(ai_dead_wire),
		 .p_dead(p_dead_wire),
		 .move_op(SW[17:16]),
		 .catch_success(catch_success_wire),
	    .victory(LEDG[8]),
	    .loss(LEDR[17]),
		 .active_trainer(actr_wire),
		 .load_ai_hp(load_ai_hp_wire),
		 .apply_p_damage(apply_p_dmg_wire),
		 .apply_ai_damage(apply_ai_dmg_wire),
		 .target(target_wire),
		 .p_heal(p_heal_wire),
		 .catch(catch_wire),
		 .catch_fail(LEDR[16]),
		 .caught(LEDG[7]),
		 .state1(LEDR[0]),
		 .state2(LEDR[1]),
		 .state3(LEDR[2]),
		 .state4(LEDR[3]),
		 .state5(LEDR[4]),
		 .state6(LEDR[5])
    );
	 
//	 move_mux move_disp (
//	     .pl_move(SW[1:0]),
//		  .dmg(move_disp_wire[3:0]),
//		  .accu(move_disp_wire[7:4])
//		  );
//		  
	
	
//	hex_display p_hp_disp(
//							.IN(p_hp_wire), 
//							.OUT(HEX4[6:0])
//							);
//	
//	hex_display ai_hp_disp(
//							.IN(ai_hp_wire), 
//							.OUT(HEX5[6:0])
//							);
	
	hex_display2 dmg_disp2(
							.IN(move_disp_wire[3:0]), 
							.ONES_DGT(HEX0[6:0]), 
							.TENS_DGT(HEX1[6:0])
							);
	
	hex_display2 accu_disp2(
							.IN(move_disp_wire[7:4]), 
							.ONES_DGT(HEX2[6:0]), 
							.TENS_DGT(HEX3[6:0])
							);
	
	hex_display2 p_hp_disp2(
							.IN(p_hp_wire[3:0]), 
							.ONES_DGT(HEX4[6:0]), 
							.TENS_DGT(HEX5[6:0])
							);
	
	hex_display2 ai_hp_disp2(
							.IN(ai_hp_wire[3:0]), 
							.ONES_DGT(HEX6[6:0]), 
							.TENS_DGT(HEX7[6:0])
							);
	 
	
endmodule

module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule

module hex_display2(IN, ONES_DGT, TENS_DGT);
    input [3:0] IN;
	 output reg [7:0] ONES_DGT, TENS_DGT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000:begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b1000000;
		       end
			4'b0001: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b1111001;
				 end
			4'b0010: begin
				 TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0100100;
			    end
			4'b0011: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0110000;
				 end
			4'b0100: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0011001;
				 end
			4'b0101: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0010010;
				 end
			4'b0110: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0000010;
				 end
			4'b0111: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b1111000;
				 end
			4'b1000: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0000000;
				 end
			4'b1001: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b0011000;
				 end
			4'b1010: begin
			    TENS_DGT = 7'b1111001;
			    ONES_DGT = 7'b1000000;
				 end
			4'b1011: begin
			    TENS_DGT = 7'b1111001;
				 ONES_DGT = 7'b1111001;
			    end
			4'b1100: begin
			    TENS_DGT = 7'b1111001;
			    ONES_DGT = 7'b0100100;
				 end
			4'b1101: begin
			    TENS_DGT = 7'b1111001;
			    ONES_DGT = 7'b0110000;
				 end
			4'b1110: begin
			    TENS_DGT = 7'b1111001;
			    ONES_DGT = 7'b0011001;
				 end
			4'b1111: begin
			    TENS_DGT = 7'b1111001;
				 ONES_DGT = 7'b0010010;
			    end
			
			default: begin
			    TENS_DGT = 7'b1000000;
			    ONES_DGT = 7'b1000000;
				 end
		endcase

	end
endmodule