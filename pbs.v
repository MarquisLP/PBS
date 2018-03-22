module pbs(SW, LEDR, LEDG, KEY, HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
	input [17:0] SW;
	output [17:0] LEDR;
	output [7:0]  LEDG;
	input [3:0] KEY;
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
	
	reg [3:0] hp1 = 4'b1001;
	reg [3:0] hp2 = 4'b0101;
	
	wire target_wire;
	wire actr_wire;
	wire calc_dmg_wire;
	wire apply_dmg_wire;
	
	wire [7:0] move_disp_wire;
	
	pbs_dp dp (
	
	           .target(target_wire),
				  .p_move(SW[1:0]),
				  .actr(actr_wire),
				  .calc_dmg(calc_dmg_wire),
				  .app_dmg(apply_dmg_wire),
				  .clk(KEY[0]),
				  .rst(SW[9]),
				  .p_hp(p_hp_wire),
				  .AI_hp(ai_hp_wire)
				  );
   
	control fsm (
       .clk(KEY[0]),
       .reset_n(SW[9]),
       .go(1'b1),
       .p_hp(p_hp_wire),
       .ai_hp(ai_hp_wire),
	    .calc_damage(calc_dmg_wire),
	    .victory(LEDG[7]),
	    .loss(LEDR[17]),
		 .active_trainer(actr_wire),
		 .apply_damage(apply_dmg_wire),
		 .target(target_wire)
    );
	 
	 move_mux move_disp (
	     .pl_move(SW[1:0]),
		  .dmg(move_disp_wire[3:0]),
		  .accu(move_disp_wire[7:4])
		  );
	
	hex_display dmg_disp(
							.IN(move_disp_wire[3:0]), 
							.OUT(HEX0[6:0])
							);
	
	hex_display accu_disp(
							.IN(move_disp_wire[7:4]), 
							.OUT(HEX2[6:0])
							);
	
	hex_display p_hp_disp(
							.IN(p_hp_wire), 
							.OUT(HEX4[6:0])
							);
	
	hex_display ai_hp_disp(
							.IN(ai_hp_wire), 
							.OUT(HEX6[6:0])
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