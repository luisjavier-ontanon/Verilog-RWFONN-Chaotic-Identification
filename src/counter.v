// Contador de pasos para habilitar las salidas de integradores.
// Se espera a max_count hasta que termina todos los bloques
module counter #(parameter max_count = 7)
	(
	input clk, rst,
	output reg load
	);
	
	// Declaración de señal interna que lleva la cuenta
	integer count;
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			count <= 0;
			load <= 1'b0;
		end
		
		else begin
			if (count==max_count) begin
				count <= 0;
				load <= 1'b1;
			end	
			else begin
			 	count <= count +1;
				 load <= 1'b0;			
			end	
		end		
	end
		
endmodule