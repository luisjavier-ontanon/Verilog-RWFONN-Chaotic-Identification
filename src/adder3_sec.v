							  									 // El # significa parámetros internos nbits número de bits de entrada
// Si la suma max es de 32, se incluye el carry aquí.

module adder3_sec #(parameter nbits = 32,fraccion = 20)	
	( 
	input clk, rst,
	input  [nbits-1:0] A, B, C, 
	output reg [nbits-1:0] sum
	);
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			sum <= {nbits{1'b0}};  // A la suma que es de 32 bits, dele 0's para toda la palabra dew datos, concatenacion
			  
		end else begin
			sum <= $signed(A) + $signed(B) + $signed(C);	  // por default las restas son en C2  < es sintaxis no-bloqueante
		end
	end
endmodule