module pbs_dp(target, p_move, actr, app_dmg, clk, rst, p_hp, AI_hp);
	input target;
	input [1:0]p_move;
	input actr;
	input app_dmg;
	input clk;
	input rst;
	output reg [3:0] p_hp;
	output reg [3:0] AI_hp;
	
	wire [1:0] airng_wire;
	wire [3:0] moveaccurng_wire;
	reg [1:0] actr_wire;
	wire [3:0] dmg_wire;
	wire [3:0] accu_wire;
	reg [3:0] curr_hp;
	wire [3:0] newhp_wire;
	reg enable_alu;
	
	initial begin
	    p_hp <= 4'b1111;
		 AI_hp <= 4'b1111;
	end
	
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
	
	move_mux mm1(
				.pl_move(actr_wire),
				.dmg(dmg_wire),
				.accu(accu_wire)
					);
	
	always @(posedge clk) // Trainer Mux
	begin
		case (actr) // start case statement
		1'b0:
			 actr_wire <= p_move;
		1'b1: 
			 actr_wire <= airng_wire;
		endcase
   end
	
//	always @(posedge clk) // Current HP mux
//	begin
//	   begin
//	   if (calc_dmg)
//		   begin
//				case (target) // start case statement
//				1'b0: 
//						curr_hp <= p_hp;
//				1'b1: 
//						curr_hp <= AI_hp;
//				endcase
//			end
//	   end
//   end
//	
//	always @(posedge clk) // New HP mux
//	begin
//	   begin
//	   if(!rst)
//		    begin
//          p_hp <= 4'b1111;
//		    AI_hp <= 4'b1111;
//			 end
//	   else
//			begin
//			   if (app_dmg)
//				   begin
//					case (target) // start case statement
//					   1'b0: p_hp <= newhp_wire;
//					   1'b1: AI_hp <= newhp_wire;
//					endcase
//				end
//			end
//	   end
//   end
	
//	dmg_alu dmg1(
//			.dmg(dmg_wire),
//			.curr_hp(curr_hp),
//			.clk(clk),
//			.enable(enable_alu),
//			.new_hp(newhp_wire)
//			);
	
	always @(posedge clk)
	begin
		begin
	    if(!rst)
		    begin
          p_hp <= 4'b1111;
		    AI_hp <= 4'b1111;
			 end
	    else if (app_dmg)
	   // else if ((accu_wire >= moveaccurng_wire) && (app_dmg))
				case (target) // start case statement
				1'b0:
				   begin
					   if (p_hp - dmg_wire < 0)
						    p_hp <= 0;
					   else
						    p_hp <= p_hp - dmg_wire;
					end
				1'b1: 
				   begin
					   if (AI_hp - dmg_wire < 0)
						    AI_hp <= 0;
					   else
						    AI_hp <= AI_hp - dmg_wire;
					end
				 endcase
		 end
	end

endmodule
