module dmg_alu(dmg, curr_hp, enable, clk, new_hp);
	input [3:0] dmg;
	input [3:0] curr_hp;
	input enable;
	input clk;
	output reg [3:0] new_hp;
	
	always@(posedge clk)
	begin
		begin
	    if (enable)
		      begin
				if (dmg > curr_hp)
				    new_hp <= 0;
			   else
				    new_hp <= curr_hp - dmg;
				end
		end
	end
	
endmodule