
module scm_alpha2 #(parameter nbits = 32, fraccion=20) (	
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
 
    w1,
    w1048576,
    w1048576_;

  assign w1 = A;
  assign w1048576 = w1 << 20;
  assign w1048576_ = -1 * w1048576;
							   

   always @(posedge clk or negedge rst) begin
	  	if (!rst) begin
		  out1 <= {nbits{1'b0}};
	  	end
	  	else begin

  		  out1 <= w1048576_[nbits+fraccion-1:fraccion];
			
		end
   end

 

endmodule //multiplier_block


										
  