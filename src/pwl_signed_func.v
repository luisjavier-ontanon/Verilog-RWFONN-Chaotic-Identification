module pwl_signed_func #(parameter nbits = 32, fraccion=20) (  
	input clk, rst,
    input  signed [31:0] x,
    output reg signed [31:0] b
);

    // Formato fijo 1.11.20
    // 0.3 aproximadamente representado como round(0.3 * 2^20)
    localparam signed [31:0] X_03 = 32'sd314573;

    // 0.9 aproximadamente representado como round(0.9 * 2^20)
    localparam signed [31:0] B_09 = 32'sd943718;

    //assign b = (x > X_03) ? B_09 : 32'sd0;	
	
	
 	always @(posedge clk or negedge rst) begin
	  	if (!rst) begin
		  b <= {nbits{1'b0}};
	  	end
	  	else begin

		  b <= (x > X_03) ? B_09 : 32'sd0;
		  
		end
   	end
   

endmodule