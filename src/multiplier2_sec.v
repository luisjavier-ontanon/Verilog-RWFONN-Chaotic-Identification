	
module multiplier2_sec #(parameter nbits = 32, fraccion=20)	
	( 
	input clk, rst,
	input  [nbits-1:0] A, B, 
	output reg [nbits-1:0] out1
	);
	
	// Asignar reg interno para cachar la mult de 64 bits
	reg [nbits+nbits-1:0] aux;
	
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin	
			//aux <= 64'b0;
			aux <= {nbits*2{1'b0}};	// opción de parametrización
			out1 <= {nbits{1'b0}};  // A la suma que es de 32 bits, dele 0's para toda la palabra dew datos, concatenacion
			
			//sum <= 32'00000000000000000000000000000000;  
		end else begin
			aux <= $signed(A) * $signed(B);
			//out1 <= aux[51:20];	  // truncamiento de bits fraccionarios	 para no tener overflow
			out1 <= aux[fraccion+nbits-1:fraccion];
		end
	end
endmodule