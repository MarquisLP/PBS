module pbs_dp(target, heal, catch, stop, p_move, actr, load_ai_hp, app_pl_dmg, app_ai_dmg, clk, rst, p_hp, AI_hp, dmg, accu, ai_dead, p_dead, moveaccurng, catch_success);
	input target;
	input heal;
	input catch;
	input [1:0]p_move;
	input actr;
	input load_ai_hp;
	input app_pl_dmg;
	input app_ai_dmg;
	input clk;
	input rst;
	input stop;
	output reg [3:0] p_hp;
	output reg [3:0] AI_hp;
	output reg [3:0] dmg;
	output reg [3:0] accu;
	output reg ai_dead;
	output reg p_dead;
	output reg catch_success;
	
	wire [1:0] airng_wire;
	wire [3:0] moveaccurng_wire;
	output reg [3:0] moveaccurng;
	reg [1:0] actr_wire;
	wire [3:0] dmg_wire;
	wire [3:0] accu_wire;
	wire [3:0] catch_wire;
	reg [3:0] curr_ai_hp;
	reg [3:0] p_out;
	reg [3:0] ai_out;
	
	
	initial begin
	    p_hp <= 4'b1111;
		 AI_hp <= 4'b1111;
		 ai_dead <= 1'b0;
	end
	
	
	
	GARO AI_rng1(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(airng_wire[0])
				);
	
	GARO AI_rng2(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(airng_wire[1])
				);
	
	GARO move_accurng1(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[0])
				);
	
	GARO move_accurng2(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[1])
				);
	
	GARO move_accurng3(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[2])
				);
	
	GARO move_accurng4(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(moveaccurng_wire[3])
				);
	
	GARO catch_rng1(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(catch_wire[0])
				);
	
	GARO catch_rng2(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(catch_wire[1])
				);
	
	GARO catch_rng3(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(catch_wire[2])
				);
	
	GARO catch_rng4(
	         .stop(stop),
				.clk(clk),
				.reset(rst),
				.random(catch_wire[3])
				);
	
	move_mux mm1(
				.pl_move(actr_wire),
				.dmg(dmg_wire),
				.accu(accu_wire)
					);
					
	
	
	always @(*) // Trainer Mux
	begin
		case (actr) // start case statement
		1'b0:
			 actr_wire = p_move;
		1'b1: 
			 actr_wire = airng_wire;
		endcase
   end

   always @(*) begin
	    dmg <= dmg_wire;
		 accu <= accu_wire;
		 moveaccurng <= moveaccurng_wire;
	end
	
	always @(*) begin
	    if (AI_hp == 4'b0000)
		     ai_dead <= 1'b1;
		 else
		     ai_dead <= 1'b0;
	end
	
	always @(*) begin
	    if (p_hp == 4'b0000)
		     p_dead <= 1'b1;
		 else
		     p_dead <= 1'b0;
	end
	
	always @(*) begin
	    catch_success = 1'b0;
	    if (catch) begin
		      if (catch_wire > AI_hp)
				    catch_success = 1'b1;
		 end
	end

   always @(posedge clk) begin
		 if (!rst) begin
		     p_hp <= 4'b1111;
			  AI_hp <= 4'b1111;
		 end
		 else if (heal) begin
		     if ((p_hp + 4'b0101) < p_hp)
					p_hp <= 4'b1111;
			  else
			      p_hp <= p_hp + 4'b0101;
		 end
	    else begin
		     if ((app_ai_dmg) && (moveaccurng_wire < accu)) begin
			      if (dmg_wire > AI_hp)
			          AI_hp <= 4'b0000;
			      else
		            AI_hp <= AI_hp - dmg_wire;
			  end
			  else begin
			     if ((app_pl_dmg) && (moveaccurng_wire < accu)) begin
				      if (dmg_wire > p_hp)
			             p_hp <= 4'b0000;
			         else
		                p_hp <= p_hp - dmg_wire;
				  end
			  end
	    end
	end


endmodule
