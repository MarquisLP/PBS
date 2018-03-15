module pbs(HEX0, KEY);
 
 // Inputs
 input HEX0;
 input [3:0] KEY;
 reg clock;
 reg reset;
 
 // Outputs
 wire [12:0] rnd;
 
 // Instantiate the Unit Under Test (UUT)
 LFSR uut (
  .clock(KEY[0]), 
  .reset(reset), 
  .rnd(rnd)
 );
  
// initial begin
//  clock = 0;
//  forever
//   #50 clock = ~clock;
//  end
   
 initial begin
  // Initialize Inputs
   
  reset = 0;
 
  // Wait 100 ns for global reset to finish
  #100;
      reset = 1;
  #200;
  reset = 0;
  // Add stimulus here
 
 end
 
  hex_display hex0(
     .IN(rnd[3:0]),
	  .OUT(HEX0)
  );
  
  
endmodule



module LFSR (
    input clock,
    input reset,
    output [12:0] rnd 
    );
 
	wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0]; 
 
	reg [12:0] random, random_next, random_done;
	reg [3:0] count, count_next; //to keep track of the shifts
 
	always @ (posedge clock or posedge reset)
	begin
		if (reset)
			begin
				random <= 13'hF; //An LFSR cannot have an all 0 state, thus reset to FF
				count <= 0;
			end 
		else
			begin
				random <= random_next;
				count <= count_next;
			end
	end
 
	always @ (*)
	begin
		random_next = random; //default state stays the same
		count_next = count;
   
		random_next = {random[11:0], feedback}; //shift left the xor'd every posedge clock
		count_next = count + 1;
 
		if (count == 13'hF)
			begin
				count = 0;
				random_done = random; //assign the random number to output after 13 shifts
			end
  
	end
 
 
	assign rnd = random_done;
 
endmodule

module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule
