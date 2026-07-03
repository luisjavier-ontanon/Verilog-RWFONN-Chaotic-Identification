module UDS_RWFONN #(parameter nbits = 32, fraccion = 20)
	(
	input clk, rst,
	output [nbits-1:0] xm_out,ym_out,zm_out,
	output [nbits-1:0] xs_out,ys_out,zs_out,
	output [nbits-1:0] w1_out,w2_out,w3_out
	);
	
	wire en;
	wire [nbits-1:0] xm, ym, zm, xs, ys, zs, w1, w2, w3; 
	wire [nbits-1:0] evalxm, evalym, evalzm;  
	wire [nbits-1:0] evalxs, evalys, evalzs;
	wire [nbits-1:0] evalw1, evalw2, evalw3;
	
	wire [nbits-1:0] aux_xm, aux_ym, aux_zm;
	wire [nbits-1:0] aux_xs, aux_ys, aux_zs;
	wire [nbits-1:0] aux_w1, aux_w2, aux_w3;
	///////////////////////////////////////////////////////////////////////////////////////
	// Evaluación de la ecuación diferencial
	
	eval_UDS_RWFONN 	#(.nbits(nbits), .fraccion(fraccion))	sistema	(
	.clk(clk), 
	.rst(rst),
	.xm(xm),
	.ym(ym),
	.zm(zm), 
	.xs(xs),
	.ys(ys),
	.zs(zs),
	.w1(w1),
	.w2(w2),
	.w3(w3),
	.evalxm(evalxm),
	.evalym(evalym),
	.evalzm(evalzm), 
	.evalxs(evalxs),
	.evalys(evalys),
	.evalzs(evalzs),
	.evalw1(evalw1),
	.evalw2(evalw2),
	.evalw3(evalw3)
	); 
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Integrador por Forward Euler	para UDS
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_xm	(
	.clk(clk), 
	.rst(rst),
	.eval(evalxm),
	.in0(xm),
	.out1(aux_xm)
	);
	
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_ym	(
	.clk(clk), 
	.rst(rst),
	.eval(evalym),
	.in0(ym),
	.out1(aux_ym)
	);
	
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_zm	(
	.clk(clk), 
	.rst(rst),
	.eval(evalzm),
	.in0(zm),
	.out1(aux_zm)
	);
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	// Integrador por Forward Euler	para red
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_xs	(
	.clk(clk), 
	.rst(rst),
	.eval(evalxs),
	.in0(xs),
	.out1(aux_xs)
	);
	
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_ys	(
	.clk(clk), 
	.rst(rst),
	.eval(evalys),
	.in0(ys),
	.out1(aux_ys)
	);
	
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_zs	(
	.clk(clk), 
	.rst(rst),
	.eval(evalzs),
	.in0(zs),
	.out1(aux_zs)
	);

	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	// Integrador por Forward Euler	para filtrado del error
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_w1	(
	.clk(clk), 
	.rst(rst),
	.eval(evalw1),
	.in0(w1),
	.out1(aux_w1)
	);
	
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_w2	(
	.clk(clk), 
	.rst(rst),
	.eval(evalw2),
	.in0(w2),
	.out1(aux_w2)
	);
	
	
	fe_integrator 	#(.nbits(nbits), .fraccion(fraccion))	fe_int_w3	(
	.clk(clk), 
	.rst(rst),
	.eval(evalw3),
	.in0(w3),
	.out1(aux_w3)
	);

	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	// Registros  para UDS
	
	pipo_register  #(.nbits(nbits), .fraccion(fraccion), .initial1(32'h00033333)) reg1xm (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_xm),
	.q(xm)
	); 
	 
		
	pipo_register  #(.nbits(nbits),.fraccion(fraccion), .initial1(32'h00033333)) reg1ym (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_ym),
	.q(ym)
	); 
	
	
	pipo_register  #(.nbits(nbits),.fraccion(fraccion), .initial1(32'h00033333)) reg1zm (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_zm),
	.q(zm)
	); 
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	// Registros  para red
	
	pipo_register  #(.nbits(nbits), .fraccion(fraccion), .initial1(32'h00080000)) reg1xs (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_xs),
	.q(xs)
	); 
	 
		
	pipo_register  #(.nbits(nbits),.fraccion(fraccion), .initial1(32'h00080000)) reg1ys (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_ys),
	.q(ys)
	); 
	
	
	pipo_register  #(.nbits(nbits),.fraccion(fraccion), .initial1(32'h00080000)) reg1zs (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_zs),
	.q(zs)
	); 

	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	// Registros  para filtrado error
	
	pipo_register  #(.nbits(nbits), .fraccion(fraccion), .initial1(32'h00000000)) reg1w1 (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_w1),
	.q(w1)
	); 
	 
		
	pipo_register  #(.nbits(nbits),.fraccion(fraccion), .initial1(32'h00000000)) reg1w2 (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_w2),
	.q(w2)
	); 
	
	
	pipo_register  #(.nbits(nbits),.fraccion(fraccion), .initial1(32'h00000000)) reg1w3 (	
	.clk(clk), 
	.rst(rst),
	.en(en),
	.d(aux_w3),
	.q(w3)
	); 
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	
	
	counter	 #(.max_count(20)) 	counterx (
	.clk(clk), 
	.rst(rst),
	.load(en)
	);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////// 
	
	assign xm_out = xm;
	assign ym_out = ym;
	assign zm_out = zm;
	
	assign xs_out = xs;
	assign ys_out = ys;
	assign zs_out = zs;
	
	assign w1_out = w1;
	assign w2_out = w2;
	assign w3_out = w3;
	
	
	endmodule