module pbs_dp(target, stop, p_move, actr, load_ai_hp, app_pl_dmg, app_ai_dmg, clk, rst, p_hp, AI_hp, dmg, accu);
	input target;
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
	
	wire [1:0] airng_wire;
	wire [3:0] moveaccurng_wire;
	reg [1:0] actr_wire;
	wire [3:0] dmg_wire;
	wire [3:0] accu_wire;
	reg [3:0] curr_ai_hp;
	reg [3:0] p_out;
	reg [3:0] ai_out;
	
	
	initial begin
	    p_hp <= 4'b1111;
		 AI_hp <= 4'b1111;
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
	
//	always @(posedge clk)
//	//always @(posedge app_dmg or negedge rst)
//	begin
//		begin
//		 dmg <= dmg_wire;
//		 accu <= accu_wire;
//	    if(!rst)
//		    begin
//          p_hp <= 5'b01111;
//		    AI_hp <= 5'b01111;
//			 end
//	    else if (app_dmg)
//	    //else if ((accu >= moveaccurng_wire) && (app_dmg))
//				case (target) // start case statement
//				1'b0:
//				   begin
//					   if (dmg > p_hp)
//						    p_hp <= 0;
//					   else
//						    p_hp <= p_hp - dmg;
//
//					end
//				1'b1: 
//				   begin
//					   if (1'b0)
//							
//						    AI_hp <= dmg; // 00011
//					   else
//							 
//						    AI_hp <= curr_hp - 5'b00011;
//					
//					end
//				 endcase
//		 end
//	end

   always @(*) begin
	    dmg <= dmg_wire;
		 accu <= accu_wire;
	end

   always @(posedge clk) begin
		 if (!rst) begin
		     p_hp <= 4'b1111;
			  AI_hp <= 4'b1111;
		 end
	    else begin
		     if (app_ai_dmg) begin
		         if (dmg_wire > AI_hp)
			          AI_hp <= 4'b0000;
			      else
		            AI_hp <= AI_hp - dmg_wire;
			  end
	    end
	end
//
//   always@(posedge clk) begin
//	     if(!rst) begin
//		      curr_ai_hp <= 4'b1111;
//		  end
//		  else begin
//		      if (load_ai_hp) begin
//				    curr_ai_hp <= AI_hp;
//				end
//		  end
//   end
//
//   always@(posedge clk) begin
//        if(!rst) begin
//            p_hp <= 4'b1111;
//			   AI_hp <= 4'b1111;	
//        end
//        else 
//            if(app_pl_dmg)
//                p_hp <= p_out;
//			   else if (app_ai_dmg)
//				    AI_hp <= ai_out;
//    end
//
//  always @(*)
//    begin 
//		  dmg <= dmg_wire;
//		  accu <= accu_wire;
//		  begin
//		     if (dmg > curr_p_hp)
//			     p_out <= 4'b0000;
//			  else
//			     p_out <= curr_p_hp - dmg;   
//		  end
//		  begin
//		     if (dmg > AI_hp)
//			     ai_out <= 4'b0000;
//			  else
//			     ai_out <= curr_ai_hp - dmg;   
//		  end
//    end

endmodule
