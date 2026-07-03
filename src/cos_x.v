															 
module cos_x #(parameter nbits = 32, fraccion = 20)	
( 
    input clk, rst,
    //input  [nbits-1:0] x,
    //output reg [nbits-1:0] out1
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
	wire [nbits-1:0] aux6;

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

    // x4 = x2*x2
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) mult2 (
        .clk(clk), 
        .rst(rst),
        .A(x2),
        .B(x2),
        .out1(x4)
    );	
	
    // x6 = x4*x2
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) mult3 (
        .clk(clk), 
        .rst(rst),
        .A(x2),
        .B(x4),
        .out1(x6)
    );

    // aux1 = x^2 / 2!
    scm_div2factorial #(.nbits(nbits), .fraccion(fraccion)) scm1 (
        .clk(clk), 
        .rst(rst),
        .A(x2),
        .out1(aux1)
    );

    // aux2 = x^4 / 4!
    scm_div4factorial #(.nbits(nbits), .fraccion(fraccion)) scm2 (
        .clk(clk), 
        .rst(rst),
        .A(x4),
        .out1(aux2)
    );	
	
    // aux3 = x^6 / 6!
    scm_div6factorial #(.nbits(nbits), .fraccion(fraccion)) scm3 (
        .clk(clk), 
        .rst(rst),
        .A(x6),
        .out1(aux3)
    );	  
	

    // aux4 = 1 - x^2/2 
    substractor2_sec #(.nbits(nbits), .fraccion(fraccion)) sub1 (	
        .clk(clk), 
        .rst(rst),
        .A(uno),
        .B(aux1), 
		.out1(aux4)
    );
	
   // aux5 = x^4/4!  - x^6/6! 
    substractor2_sec #(.nbits(nbits), .fraccion(fraccion)) sub2 (	
        .clk(clk), 
        .rst(rst),
        .A(aux2),
        .B(aux3), 
		.out1(aux5)
    );
	
	

    // aux6 = aux4 + aux6
    adder2_sec #(.nbits(nbits), .fraccion(fraccion)) add1 (	
        .clk(clk), 
        .rst(rst),
        .A(aux4),
        .B(aux5),
        .sum(aux6)
    );
	
    always @(posedge clk or negedge rst) begin
        if (!rst) begin	
            out1 <= {nbits{1'b0}};
        end 
        else begin
            out1 <= aux6;
        end
    end

endmodule
//								  	
