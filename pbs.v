module pbs(SW, LEDR, LEDG, CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	input [17:0] SW;
	output [17:0] LEDR;
	output [7:0]  LEDG;
	input [3:0] KEY;
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
	wire go;
	assign go = ~KEY[3];
	
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
				  .clk(CLOCK_50),
				  .rst(SW[9]),
				  .p_hp(p_hp_wire),
				  .AI_hp(ai_hp_wire)
				  );
   
	control fsm (
       .clk(CLOCK_50),
       .reset_n(SW[9]),
       .go(go),
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
							.ONES_DGT(HEX0[6:0]), 
							.TENS_DGT(HEX1[6:0])
							);
	
	hex_display accu_disp(
							.IN(move_disp_wire[7:4]), 
							.ONES_DGT(HEX2[6:0]), 
							.TENS_DGT(HEX3[6:0])
							);
	
	hex_display p_hp_disp(
							.IN(p_hp_wire), 
							.ONES_DGT(HEX4[6:0]), 
							.TENS_DGT(HEX5[6:0])
							);
	
	hex_display ai_hp_disp(
							.IN(ai_hp_wire), 
							.ONES_DGT(HEX6[6:0]), 
							.TENS_DGT(HEX7[6:0])
							);
	 
	
endmodule

module hex_display(IN, ONES_DGT, TENS_DGT);
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