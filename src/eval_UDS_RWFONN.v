module eval_UDS_RWFONN #(parameter nbits = 32, fraccion = 20)
	(
	input clk, rst,
	input [nbits-1:0] xm,ym,zm,   // Estados UDS
	input [nbits-1:0] xs,ys,zs,   // Estados de la Red
	input [nbits-1:0] w1,w2,w3,   // Estados del filtrado del error
	output [nbits-1:0] evalxm,evalym,evalzm,     // Estados UDS 
	output [nbits-1:0] evalxs,evalys,evalzs,     // Estados Red
	output [nbits-1:0] evalw1,evalw2,evalw3      // Estados Filtrado del error
	);
	
	// Declaración de señales internas
	//wire en;
	wire [nbits-1:0] aux1_zm, aux2_zm, aux3_zm, aux4_zm;	 // Auxiliares para UDS
	
	wire [nbits-1:0] aux1_xs, aux2_xs, aux3_xs, aux4_xs, aux5_xs;	 // Auxiliares para red	 xs
	wire [nbits-1:0] aux1_ys, aux2_ys, aux3_ys, aux4_ys, aux5_ys;	 // Auxiliares para red	 ys
	wire [nbits-1:0] aux1_zs, aux2_zs, aux3_zs, aux4_zs, aux5_zs;	 // Auxiliares para red	 zs	
	
	wire [nbits-1:0] aux1_w1, aux2_w1, aux3_w1;	 // Auxiliares para red	 w1	
	wire [nbits-1:0] aux1_w2, aux2_w2, aux3_w2;	 // Auxiliares para red	 w2
	wire [nbits-1:0] aux1_w3, aux2_w3, aux3_w3;	 // Auxiliares para red	 w3
	
	/////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	// Aquí inicia la instanciación de bloques del sistema UDS
	// dxm = ym 
	 assign evalxm = ym;
	
	// dym = zm 
	assign evalym = zm;
	
	//dzm = -alpha1xm - alpha2ym - alpha3zm + pwl
	
	scm_alpha1	#(.nbits(nbits),.fraccion(fraccion)) 	scm1z (
	.clk(clk), 
	.rst(rst),
	.A(xm),
	.out1(aux1_zm)
	);
	
	scm_alpha2	#(.nbits(nbits),.fraccion(fraccion)) 	scm2z (
	.clk(clk), 
	.rst(rst),
	.A(ym),
	.out1(aux2_zm)
	);
	
	scm_alpha2	#(.nbits(nbits),.fraccion(fraccion)) 	scm3z (
	.clk(clk), 
	.rst(rst),
	.A(zm),
	.out1(aux3_zm)
	);	
	
	pwl_signed_func	#(.nbits(nbits),.fraccion(fraccion)) 	pwlz (
	.clk(clk), 
	.rst(rst),
	.x(xm),
	.b(aux4_zm)
	);	
	
     adder4_sec	#(.nbits(nbits),.fraccion(fraccion)) 	add1x (	
	.clk(clk), 
	.rst(rst),
	.A(aux1_zm),
	.B(aux2_zm),
	.C(aux3_zm),
	.D(aux4_zm),
	.sum(evalzm)
	);	
	

	
	/////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	// Aquí inicia la instanciación de bloques de la red
	// dxs = -a1*xs  - b1*w1*fun_act_x1  + ys
   
	//a1 = 5
	//	aux1_xs = -a1* xs
	scm_minus5	#(.nbits(nbits),.fraccion(fraccion)) 	scm1xs (
	.clk(clk), 
	.rst(rst),
	.A(xs),
	.out1(aux1_xs)
	);
	
	//b1 = 5
	//	aux2_xs = b1* w1
	scm_5	#(.nbits(nbits),.fraccion(fraccion)) 	scm2xs(
	.clk(clk), 
	.rst(rst),
	.A(w1),
	.out1(aux2_xs)
	);
	
		
	//  aux3_xs = psi (xm)
	fun_act_morlet	#(.nbits(nbits),.fraccion(fraccion)) 	fun_act_xm (
	.clk(clk), 
	.rst(rst),
	.x(xm),
	.out1(aux3_xs)
	);
	
   // aux4_xs = b1w1 * psi(x)
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) multx (
        .clk(clk), 
        .rst(rst),
        .A(aux2_xs),
        .B(aux3_xs),
        .out1(aux4_xs)
    );	

 	// aux5_xs  =  aux1_xs + aux4_xs  + ys
     adder3_sec	#(.nbits(nbits),.fraccion(fraccion)) 	add1xs (	
	.clk(clk), 
	.rst(rst),
	.A(aux1_xs),
	.B(aux4_xs),
	.C(ys),
	.sum(aux5_xs)
	);	
	
	////////////////////////////////////////////////////////////////////////////////////
	// dys = -a2*ys  - b2*w2*fun_act_y  + zs
   
	//a2 = 5
	//	aux1_ys = -a2* ys
	scm_minus5	#(.nbits(nbits),.fraccion(fraccion)) 	scm1ys (
	.clk(clk), 
	.rst(rst),
	.A(ys),
	.out1(aux1_ys)
	);
	
	//b2 = 5
	//	aux2_ys = b2* w2
	scm_5	#(.nbits(nbits),.fraccion(fraccion)) 	     scm2ys (
	.clk(clk), 
	.rst(rst),
	.A(w2),
	.out1(aux2_ys)
	);
	
		
	//  aux3_ys = psi (y)
	fun_act_morlet	#(.nbits(nbits),.fraccion(fraccion)) 	fun_act_ym (
	.clk(clk), 
	.rst(rst),
	.x(ym),
	.out1(aux3_ys)
	);
	
   // aux4_ys = b2w2 * psi(y)
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) multy (
        .clk(clk), 
        .rst(rst),
        .A(aux2_ys),
        .B(aux3_ys),
        .out1(aux4_ys)
    );	

 	// aux5_ys  =  aux1_ys + aux4_ys  + zs
     adder3_sec	#(.nbits(nbits),.fraccion(fraccion)) 	add1ys (	
	.clk(clk), 
	.rst(rst),
	.A(aux1_ys),
	.B(aux4_ys),
	.C(zs),
	.sum(aux5_ys)
	);	
	
	////////////////////////////////////////////////////////////////////////////////////
	// dzs = -a3*zs  - b3*w3*fun_act_z  + xm
   
	//a3 = 5
	//	aux1_zs = -a3* zs
	scm_minus5	#(.nbits(nbits),.fraccion(fraccion)) 	scm1zs (
	.clk(clk), 
	.rst(rst),
	.A(zs),
	.out1(aux1_zs)
	);
	
	//b3 = 5
	//	aux2_zs = b3* w3
	scm_5	#(.nbits(nbits),.fraccion(fraccion)) 	     scm2zs (
	.clk(clk), 
	.rst(rst),
	.A(w3),
	.out1(aux2_zs)
	);
	
		
	//  aux3_zs = psi (z)
	fun_act_morlet	#(.nbits(nbits),.fraccion(fraccion)) 	fun_act_zm (
	.clk(clk), 
	.rst(rst),
	.x(zm),
	.out1(aux3_zs)
	);
	
   // aux4_zs = b3w3 * psi(z)
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) multz (
        .clk(clk), 
        .rst(rst),
        .A(aux2_zs),
        .B(aux3_zs),
        .out1(aux4_zs)
    );	

 	// aux5_zs  =  aux1_zs + aux4_zs  + xm
     adder3_sec	#(.nbits(nbits),.fraccion(fraccion)) 	add1zs (	
	.clk(clk), 
	.rst(rst),
	.A(aux1_zs),
	.B(aux4_zs),
	.C(xm),
	.sum(aux5_zs)
	);	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	// Aquí inicia la instanciación de bloques del filtrado del error
	// dw1 = -delta1 * psi(x) * (xs - xm)
   
	//  delta1 = 64
	//	aux1_w1 = - delta1 * psi (xm)
	//	aux1_w1 = - delta1 * aux3_xs
	scm_minus64	#(.nbits(nbits),.fraccion(fraccion)) 	scm1w1 (
	.clk(clk), 
	.rst(rst),
	.A(aux3_xs),    // en  aux3_xs está psi(x)
	.out1(aux1_w1)
	);
	
	
	//	aux2_w1 =  (xs - xm)
	substractor2_sec #(.nbits(nbits), .fraccion(fraccion)) subsw1 (	
	.clk(clk), 
    .rst(rst),
    .A(xs),
    .B(xm),
    .out1(aux2_w1)
    );	

	
   // aux3_w1 = delta1 psi(x) * (xs-xm)
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) multw1 (
        .clk(clk), 
        .rst(rst),
        .A(aux1_w1),
        .B(aux2_w1),
        .out1(aux3_w1)
    );	

 	
	////////////////////////////////////////////////////////////////////////////////////
	// dw2 = -delta2 * psi(y) * (ys - ym)
   
	//  delta2 = 64
	//	aux1_w2 = - delta2 * psi (ym)
	//	aux1_w2 = - delta2 * aux3_ys
	scm_minus64	#(.nbits(nbits),.fraccion(fraccion)) 	scm1w2 (
	.clk(clk), 
	.rst(rst),
	.A(aux3_ys),    // en  aux3_xs está psi(x)
	.out1(aux1_w2)
	);
	
	
	//	aux2_w2 =  (ys - ym)
	substractor2_sec #(.nbits(nbits), .fraccion(fraccion)) subsw2 (	
	.clk(clk), 
    .rst(rst),
    .A(ys),
    .B(ym),
    .out1(aux2_w2)
    );	

	
   // aux3_w2 = delta2 psi(y) * (ys-ym)
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) multw2 (
        .clk(clk), 
        .rst(rst),
        .A(aux1_w2),
        .B(aux2_w2),
        .out1(aux3_w2)
    );	

   
	////////////////////////////////////////////////////////////////////////////////////
	// dw3 = -delta3 * psi(z) * (zs - zm)
   
	//  delta2 = 64
	//	aux1_w3 = - delta3 * psi (zm)
	//	aux1_w3 = - delta3 * aux3_zs
	scm_minus64	#(.nbits(nbits),.fraccion(fraccion)) 	scm1w3 (
	.clk(clk), 
	.rst(rst),
	.A(aux3_zs),    // en  aux3_xs está psi(x)
	.out1(aux1_w3)
	);
	
	
	//	aux2_w3 =  (zs - zm)
	substractor2_sec #(.nbits(nbits), .fraccion(fraccion)) subsw3 (	
	.clk(clk), 
    .rst(rst),
    .A(zs),
    .B(zm),
    .out1(aux2_w3)
    );	

	
   // aux3_w3 = delta3 psi(z) * (zs-zm)
    multiplier2_sec #(.nbits(nbits), .fraccion(fraccion)) multw3 (
        .clk(clk), 
        .rst(rst),
        .A(aux1_w3),
        .B(aux2_w3),
        .out1(aux3_w3)
    );	
	
	
	assign evalxs = aux5_xs;
	assign evalys = aux5_ys;
	assign evalzs = aux5_zs;
	
	assign evalw1 = aux3_w1;
	assign evalw2 = aux3_w2;
	assign evalw3 = aux3_w3;
	
	
	endmodule