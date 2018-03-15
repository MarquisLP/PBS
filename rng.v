module pbs(HEX0, KEY, SW);
 
 // Inputs
 input [6:0]HEX0;
 input [3:0] KEY;
 input [9:0] SW;
 reg clock;
 reg reset;
 
 // Outputs
 wire [4:0] rnd;
 
 // Instantiate the Unit Under Test (UUT)
 fibonacci_lfsr_nbit rng(
								.clk(KEY[0]),
								.rst_n(SW[1]),
								.data(rnd[4:0])
								);
  
// initial begin
//  clock = 0;
//  forever
//   #50 clock = ~clock;
//  end
   

 
  hex_display hex0(
     .IN(4'b0000),
	  .OUT(HEX0)
  );
  
  
endmodule

module fibonacci_lfsr_nbit
   #(parameter BITS = 5)
   (
    input             clk,
    input             rst_n,

    output reg [4:0] data
    );

   reg [4:0] data_next;
   always@(negedge clk)
		begin
      data_next <= data;
      repeat(BITS) 
		begin
         data_next <= {(data_next[4]^data_next[1]), data_next[4:1]};
      end
   end

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
         data <= 5'h1f;
      else
		
         data <= data_next;
   end

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
