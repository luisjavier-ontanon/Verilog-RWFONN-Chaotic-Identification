
module e_x #(parameter nbits = 32, fraccion = 20)	
( 
    input clk, rst,
    input  [nbits-1:0] x,
    output reg [nbits-1:0] out1
);

    wire [nbits-1:0] x2;
    wire [nbits-1:0] x3;
    wire [nbits-1:0] aux1;
    wire [nbits-1:0] aux2;
    wire [nbits-1:0] aux3;

    // 1.0 en formato fixed point 1.11.20
    localparam [nbits-1:0] uno = 32'h0010_0000;

    // x2 = x*x
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) mult1 (
        .clk(clk), 
        .rst(rst),
        .A(x),
        .B(x),
        .out1(x2)
    );	

    // x3 = x*x2
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) mult2 (
        .clk(clk), 
        .rst(rst),
        .A(x),
        .B(x2),
        .out1(x3)
    );	

    // aux1 = x^2 / 2
    scm_div2factorial #(.nbits(nbits), .fraccion(fraccion)) scm1 (
        .clk(clk), 
        .rst(rst),
        .A(x2),
        .out1(aux1)
    );

    // aux2 = x^3 / 6
    scm_div3factorial #(.nbits(nbits), .fraccion(fraccion)) scm2 (
        .clk(clk), 
        .rst(rst),
        .A(x3),
        .out1(aux2)
    );

    // aux3 = 1 + x + x^2/2 + x^3/6
    adder4_sec #(.nbits(nbits), .fraccion(fraccion)) add1 (	
        .clk(clk), 
        .rst(rst),
        .A(uno),
        .B(x),
        .C(aux1),
        .D(aux2),
        .sum(aux3)
    );
	
    always @(posedge clk or negedge rst) begin
        if (!rst) begin	
            out1 <= {nbits{1'b0}};
        end 
        else begin
            out1 <= aux3;
        end
    end

endmodule
//								  	
//module e_x #(parameter nbits = 32, fraccion=20)	
//	( 
//	input clk, rst,
//	input  [nbits-1:0] x,
//	output reg [nbits-1:0] out1
//	);
//	
//	// Asignar reg interno para cachar la mult de 64 bits
//	reg [nbits+nbits-1:0] x2,x3,aux1, aux2, aux3;
//	parameter uno = 32'h00100000;
//	
//	multiplier2_sec	#(.nbits(nbits),.fraccion(fraccion)) 	mult1 (
//	.clk(clk), 
//	.rst(rst),
//	.A(x),
//    .B(x),
//	.out1(x2)
//	);	
//	
//	multiplier2_sec	#(.nbits(nbits),.fraccion(fraccion)) 	mult2 (
//	.clk(clk), 
//	.rst(rst),
//	.A(x),
//    .B(x2),
//	.out1(x3)
//	);	
//	
//	
//	scm_div2factorial	#(.nbits(nbits),.fraccion(fraccion)) 	scm1 (
//	.clk(clk), 
//	.rst(rst),
//	.A(x2),
//	.out1(aux1)
//	);
//	
//	scm_div3factorial	#(.nbits(nbits),.fraccion(fraccion)) 	scm2 (
//	.clk(clk), 
//	.rst(rst),
//	.A(x3),
//	.out1(aux2)
//	);
//	
//     adder4_sec	#(.nbits(nbits),.fraccion(fraccion)) 	add1 (	
//	.clk(clk), 
//	.rst(rst),
//	.A(uno),
//	.B(x),
//	.C(aux1),
//	.D(aux2),
//	.sum(aux3)
//	);
//	
//	always @(posedge clk or negedge rst) begin
//		if (!rst) begin	
//
//			out1 <= {nbits{1'b0}};  // A la suma que es de 32 bits, dele 0's para toda la palabra dew datos, concatenacion
//			 
//		end else begin
//
//			//out1 <= aux[51:20];	  // truncamiento de bits fraccionarios	 para no tener overflow
//			//out1 <= aux3[fraccion+nbits-1:fraccion]; 
//			out1 <= aux3[nbits-1:0];
//		end
//	end
//endmodule