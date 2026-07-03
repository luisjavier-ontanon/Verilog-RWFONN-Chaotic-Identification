module pipo_register #(parameter nbits = 32, fraccion=20, initial1=32'h00100000) (	
    input clk, rst, en,
	input [nbits-1:0] d,
	output [nbits-1:0] q
);
	reg [nbits-1:0] q_aux;


    
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			q_aux <= initial1;
		end
		else begin
			if (en) begin
				q_aux <= d;
			end	
			else begin
				q_aux <= q_aux;
			end
		end
	end
	assign q = q_aux;
	
endmodule







