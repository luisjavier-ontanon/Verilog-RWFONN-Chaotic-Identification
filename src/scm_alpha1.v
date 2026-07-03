module scm_alpha1 #(parameter nbits = 32, fraccion=20) (	
    A,
    out1,
	clk,
	rst
);

 // Port mode declarations:
  input clk, rst;
  input  signed  [nbits-1:0] A;
  output reg  [nbits-1:0] out1;
  


  wire signed [nbits+fraccion-1:0]
  //Multipliers:

    w1,
    w4,
    w3,
    w1572864,
    w1572864_;

  assign w1 = A;
  assign w4 = w1 << 2;
  assign w3 = w4 - w1;
  assign w1572864 = w3 << 19;
  assign w1572864_ = -1 * w1572864;

   always @(posedge clk or negedge rst) begin
	  	if (!rst) begin
		  out1 <= {nbits{1'b0}};
	  	end
	  	else begin

  		  out1 <= w1572864_[nbits+fraccion-1:fraccion];
			
		end
   end

 

endmodule //multiplier_block
