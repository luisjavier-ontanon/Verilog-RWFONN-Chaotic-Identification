								 															 
module fun_act_morlet #(parameter nbits = 32, fraccion = 20)	
( 
    input clk, rst,
	input  signed [nbits-1:0] x,
    output reg signed [nbits-1:0] out1
);


 // Pi/2 = 001921F8


    wire [nbits-1:0] x2;
    wire [nbits-1:0] x4;
    wire [nbits-1:0] x6;
    wire [nbits-1:0] aux1;
    wire [nbits-1:0] aux2;
    wire [nbits-1:0] aux3;
	wire [nbits-1:0] aux4;
	wire [nbits-1:0] aux5;


   // x2 = x*x
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) mult1 (
        .clk(clk), 
        .rst(rst),
        .A(x),
        .B(x),
        .out1(x2)
    );	
	
	
 	//aux1 = -x2/64
	scm_div_minus_64	#(.nbits(nbits),.fraccion(fraccion)) 	scm1xm (
	.clk(clk), 
	.rst(rst),
	.A(x2),
	.out1(aux1)
	);
  
	
	
	//aux2 = e ^ ( - x2 / 64)
    e_x #(.nbits(nbits), .fraccion(fraccion)) ex1 (
        .clk(clk), 
        .rst(rst),
        .x(aux1),
		.out1(aux2)
    );	

 	//aux3 = x*0.001
	scm_0p001	#(.nbits(nbits),.fraccion(fraccion)) 	scm12xm (
	.clk(clk), 
	.rst(rst),
	.A(x),
	.out1(aux3)
	);
 

	//aux4 = cos ( x * 0.001)
    cos_x #(.nbits(nbits), .fraccion(fraccion)) cosx1 (
        .clk(clk), 
        .rst(rst),
        .x(aux3),
		.out1(aux4)
    );	
	

	
    // aux5 = e ^ ( - x2 / 64) * cos ( x * 0.001) 
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) mult3 (
        .clk(clk), 
        .rst(rst),
        .A(aux2),
        .B(aux4),
        .out1(aux5)
    );

 
	
    always @(posedge clk or negedge rst) begin
        if (!rst) begin	
            out1 <= {nbits{1'b0}};
        end 
        else begin
            out1 <= aux5;
        end
    end

endmodule
//								  	
