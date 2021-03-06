`timescale 1ns / 1ns // `timescale time_unit/time_precision
module rng(HEX0,HEX1,KEY,SW, LEDR, CLOCK_50);
	
	input [3:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [9:0] LEDR;
	//output [9:0] LEDG;
	
	reg [3:0] hp = 4'b1001;
	reg [3:0] dmg = 4'b0011;
	
	wire [3:0] randomout;
	
	hex_display hex0(
		.IN(randomout),
		.OUT(HEX0[6:0])
	);
	
	hex_display hex1(
		.IN(hp),
		.OUT(HEX1[6:0])
	);
	
	GARO rn1(
	         .stop(SW[1]),
				.clk(CLOCK_50),
				.reset(SW[0]),
				.random(randomout[0])
				);
				
	GARO rn2(
	         .stop(SW[1]),
				.clk(CLOCK_50),
				.reset(SW[0]),
				.random(randomout[1])
				);
				
	GARO rn3(
	         .stop(SW[1]),
				.clk(CLOCK_50),
				.reset(SW[0]),
				.random(randomout[2])
				);

	GARO rn4(
	         .stop(SW[1]),
				.clk(CLOCK_50),
				.reset(SW[0]),
				.random(randomout[3])
				);
				
   assign LEDR[0] = (randomout > 'd7);
	assign LEDR[1] = (randomout <= 'd7);
	
	always@(posedge KEY[0])
	begin
		begin
		 if(~KEY[0])
			if (randomout > 'd7)
		     hp <= hp - dmg;
		end
	end
	
endmodule



// RNG module using Galois Ring Oscillators (GARO), by StanOverflow:
// https://stackoverflow.com/a/26280438
module GARO (input stop, clk, reset, output random);

	(* OPTIMIZE="OFF" *)                    //stop *xilinx* tools optimizing this away
	wire [31:1] stage /* synthesis keep */; //stop *altera* tools optimizing this away
	reg meta1, meta2;

	assign random = meta2;

	always@(posedge clk or negedge reset)
	if(!reset)
	  begin
		 meta1 <= 1'b0;
		 meta2 <= 1'b0;
	  end
	else if(clk)
	  begin
		 meta1 <= stage[1];
		 meta2 <= meta1;
	  end

	assign stage[1] = ~&{stage[2] ^ stage[1],stop};
	assign stage[2] = !stage[3];
	assign stage[3] = !stage[4] ^ stage[1];
	assign stage[4] = !stage[5] ^ stage[1];
	assign stage[5] = !stage[6] ^ stage[1];
	assign stage[6] = !stage[7] ^ stage[1];
	assign stage[7] = !stage[8];
	assign stage[8] = !stage[9] ^ stage[1];
	assign stage[9] = !stage[10] ^ stage[1];
	assign stage[10] = !stage[11];
	assign stage[11] = !stage[12];
	assign stage[12] = !stage[13] ^ stage[1];
	assign stage[13] = !stage[14];
	assign stage[14] = !stage[15] ^ stage[1];
	assign stage[15] = !stage[16] ^ stage[1];
	assign stage[16] = !stage[17] ^ stage[1];
	assign stage[17] = !stage[18];
	assign stage[18] = !stage[19];
	assign stage[19] = !stage[20] ^ stage[1];
	assign stage[20] = !stage[21] ^ stage[1];
	assign stage[21] = !stage[22];
	assign stage[22] = !stage[23];
	assign stage[23] = !stage[24];
	assign stage[24] = !stage[25];
	assign stage[25] = !stage[26];
	assign stage[26] = !stage[27] ^ stage[1];
	assign stage[27] = !stage[28];
	assign stage[28] = !stage[29];
	assign stage[29] = !stage[30];
	assign stage[30] = !stage[31];
	assign stage[31] = !stage[1];

endmodule

//module fibonacci_lfsr_nbit
//   #(parameter BITS = 5)
//   (
//    input             clk,
//    input             rst_n,
//
//    output reg [4:0] data
//    );
//
//   reg [4:0] data_next;
//   always@(posedge clk) 
//	begin
//      data_next <= data;
//      repeat(BITS) 
//		begin
//         data_next <= {(data_next[4]^data_next[1]), data_next[4:1]};
//      end
//   end
//
//   always@(posedge clk) //or negedge rst_n) 
//		begin
////			begin
////				if(!rst_n)
////					data <= 5'h1f;
////				else
//					data <= data_next;
////			end
//		end
//
//endmodule


