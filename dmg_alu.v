module dmg_alu(dmg, curr_hp, clk, enable, new_hp);
	input [3:0] dmg;
	input [3:0] curr_hp;
	input clk;
	input enable;
	output reg [3:0] new_hp;
	
	initial begin
		new_hp = 4'b1111;
	end
	
	always@(*)
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