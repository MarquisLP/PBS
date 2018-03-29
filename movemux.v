module move_mux(pl_move, dmg, accu);
	input [1:0]pl_move;
	output reg [3:0] dmg;
	output reg [3:0] accu;
	
	always @(*) // declare always block
	begin
		case (pl_move[1:0]) // start case statement
		2'b00: begin
			dmg = 4'b0011;
			accu = 4'b1111;
			end
		2'b01: begin
			dmg = 4'b0111;
			accu = 4'b1100;
			end
		2'b10:  begin
			dmg = 4'b1010;
			accu = 4'b1010;
			end// case 2
		2'b11: begin
			dmg = 4'b1111;
			accu = 4'b0000;
			end // case 3
		default: begin
			dmg = 4'b0000;
			accu = 4'b1111;
			end // default case
	endcase
  end

endmodule