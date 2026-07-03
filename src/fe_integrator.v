module fe_integrator #(parameter nbits = 32, fraccion = 20)
	(
	input clk, rst,	
	input [nbits-1:0] eval,
	input [nbits-1:0] in0,
	output [nbits-1:0] out1
	);
				
	wire [nbits-1:0] aux1;
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	// Aquí inicia la instanciación de bloques
	
	scm_H 	#(.nbits(nbits),.fraccion(fraccion)) 		scm2x (	  
	.clk(clk), 
	.rst(rst),
	.A(eval),
	.out1(aux1)
	);
	
	adder2_sec	#(.nbits(nbits),.fraccion(fraccion)) 	add1x (	
	.clk(clk), 
	.rst(rst),
	.A(in0),
	.B(aux1),
	.sum(out1)
	);
	
	 
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
		
	
	endmodule