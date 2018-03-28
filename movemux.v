module move_mux(pl_move, dmg, accu);
	input [1:0]pl_move;
	output reg [4:0] dmg;
	output reg [4:0] accu;
	
	always @(*) // declare always block
	begin
		case (pl_move[1:0]) // start case statement
		2'b00: begin
			dmg = 5'b00011;
			accu = 5'b01111;
			end
		2'b01: begin
			dmg = 5'b00111;
			accu = 5'b01100;
			end
		2'b10:  begin
			dmg = 5'b01010;
			accu = 5'b01010;
			end// case 2
		2'b11: begin
			dmg = 5'b01111;
			accu = 5'b00101;
			end // case 3
		default: begin
			dmg = 5'b00000;
			accu = 5'b01111;
			end // default case
	endcase
  end

endmodule