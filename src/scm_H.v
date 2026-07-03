module scm_H #(parameter nbits = 32, fraccion=20) (	
    A,
    out1,
	clk,
	rst
);

 // Port mode declarations:
  input clk, rst;
  input  signed  [nbits-1:0] A;
  output reg  [nbits-1:0] out1;
  

  //Multipliers:

  wire signed [nbits+fraccion-1:0]
    w1,
    w2048,
    w2049,
    w8196,
    w10245,
    w16,
    w15,
    w240,
    w10485;

  assign w1 = A;
  assign w2048 = w1 << 11;
  assign w2049 = w1 + w2048;
  assign w8196 = w2049 << 2;
  assign w10245 = w2049 + w8196;
  assign w16 = w1 << 4;
  assign w15 = w16 - w1;
  assign w240 = w15 << 4;
  assign w10485 = w10245 + w240;
  
  
    always @(posedge clk or negedge rst) begin
	  	if (!rst) begin
		  out1 <= {nbits{1'b0}};
	  	end
	  	else begin

  		  out1 <= w10485[nbits+fraccion-1:fraccion];
			
		end
   end

 

endmodule //multiplier_block
