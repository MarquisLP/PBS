module pbs_dp(target, p_move, actr, calc_dmg, app_dmg, clk, rst, p_hp, AI_hp);
	input target;
	input [1:0]p_move;
	input actr;
	input calc_dmg;
	input app_dmg;
	input clk;
	input rst;
	output reg [3:0] p_hp;
	output reg [3:0] AI_hp;
	
	wire [1:0] airng_wire;
	wire [3:0] moveaccurng_wire;
	wire [1:0] actr_wire;
	wire [3:0] dmg_wire;
	wire [3:0] accu_wire;
	wire [3:0] curr_hp;
	wire [3:0] newhp_wire;
	wire enable_alu;
	
	GARO AI_rng1(
	         .stop(1'b1),
				.clk(clk),
				.reset(rst),
				.random(airng_wire[0])
				);
	
	GARO AI_rng2(
	         .stop(1'b1),
				.clk(clk),
				.reset(rst),
				.random(airng_wire[1])
				);
	
	GARO move_accurng1(
	         .stop(1'b1),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[0])
				);
	
	GARO move_accurng2(
	         .stop(1'b1),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[1])
				);
	
	GARO move_accurng3(
	         .stop(1'b1),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[2])
				);
	
	GARO move_accurng4(
	         .stop(1'b1),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[3])
				);
	
	movemux mm1(
				.pl_move(actr_wire),
				.dmg(dmg_wire),
				.accu(accu_wire)
					);
	
	always @(posedge clk) // Trainer Mux
	begin
		case (actr) // start case statement
		1'b0:
			assign actr_wire = p_move;
		1'b1: 
			assign actr_wire = airng_wire;
		
		default: 
			assign actr_wire = p_move; 
		endcase
   end
	
	always @(posedge clk) // Current HP mux
	begin
		case (target) // start case statement
		1'b0: 
			assign curr_hp = p_hp;
		1'b1: 
			assign curr_hp = AI_hp;
		default: 
			assign curr_hp = p_hp;
		endcase
   end
	
	always @(posedge clk) // New HP mux
	begin
		case (target) // start case statement
		1'b0: p_hp = newhp_wire;
		1'b1: AI_hp = newhp_wire;
		default: 
			p_hp = newhp_wire;
		endcase
   end
	
	dmg_alu dmg1(
			.dmg(dmg_wire),
			.curr_hp(curr_hp),
			.enable(enable_alu),
			.clk(clk),
			.new_hp(newhp_wire)
			);
	
	always @(posedge clk)
	begin
	    if (accu_wire >= airng_wire)
		     assign enable_alu = calc_dmg;
	    else
		     assign enable_alu = 1'b0;
	end
			
	

endmodule

