// El # significa parámetros internos nbits número de bits de entrada
// Si la suma max es de 32, se incluye el carry aquí.

module substractor2_sec #(parameter nbits = 32,fraccion = 20)
	( 
	input clk, rst,
	input  [nbits-1:0] A, B, 
	output reg [nbits-1:0] out1
	);
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			out1 <= {nbits{1'b0}};  // A la suma que es de 32 bits, dele 0's para toda la palabra dew datos, concatenacion
			//sum <= 32'00000000000000000000000000000000;  
		end else begin
			out1 <= $signed(A) - $signed(B);	  // por default las restas son en C2  < es sintaxis no-bloqueante
		end
	end
endmodule