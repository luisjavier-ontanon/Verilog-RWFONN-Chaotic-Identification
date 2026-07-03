`timescale 1ns/1ps

module tb_UDS_RWFONN;

    parameter nbits    = 32;
    parameter fraccion = 20;

    reg clk;
    reg rst;

    wire [nbits-1:0] xm_out;
    wire [nbits-1:0] ym_out;
    wire [nbits-1:0] zm_out;

    wire [nbits-1:0] xs_out;
    wire [nbits-1:0] ys_out;
    wire [nbits-1:0] zs_out;

    wire [nbits-1:0] w1_out;
    wire [nbits-1:0] w2_out;
    wire [nbits-1:0] w3_out;

    integer fd;
    integer sample_count;

    localparam integer SAMPLE_EVERY = 1;
    localparam integer SIM_TIME_NS  = 1000000;  // 1 ms
    real scale;

    // Instancia del diseño principal
    UDS_RWFONN #(
        .nbits(nbits),
        .fraccion(fraccion)
    ) dut (
        .clk(clk),
        .rst(rst),

        .xm_out(xm_out),
        .ym_out(ym_out),
        .zm_out(zm_out),

        .xs_out(xs_out),
        .ys_out(ys_out),
        .zs_out(zs_out),

        .w1_out(w1_out),
        .w2_out(w2_out),
        .w3_out(w3_out)
    );

    // Generador de reloj
    // Periodo = 20 ns
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // Reset activo en bajo
    initial begin
        rst = 1'b0;
        #100;
        rst = 1'b1;
    end

    // Abrir archivo CSV
    initial begin
        scale = 1048576.0;  // 2^20 para formato 1.11.20

        fd = $fopen("C:/My_Designs/UDS_RWFONN_9signals.csv", "w");

        if (fd == 0) begin
            $display("ERROR: no se pudo abrir el archivo CSV.");
            $finish;
        end

        $fdisplay(
            fd,
            "time_ns,xm_hex,ym_hex,zm_hex,xs_hex,ys_hex,zs_hex,w1_hex,w2_hex,w3_hex,xm_real,ym_real,zm_real,xs_real,ys_real,zs_real,w1_real,w2_real,w3_real"
        );

        sample_count = 0;
    end

    // Exportar datos.
    // Uso negedge clk para leer después de que las señales ya se actualizaron en posedge.
    always @(negedge clk) begin
        if (rst) begin
            sample_count = sample_count + 1;

            if ((sample_count % SAMPLE_EVERY) == 0) begin
                $fdisplay(
                    fd,
                    "%0.3f,%08h,%08h,%08h,%08h,%08h,%08h,%08h,%08h,%08h,%f,%f,%f,%f,%f,%f,%f,%f,%f",
                    $realtime,

                    xm_out,
                    ym_out,
                    zm_out,

                    xs_out,
                    ys_out,
                    zs_out,

                    w1_out,
                    w2_out,
                    w3_out,

                    $itor($signed(xm_out)) / scale,
                    $itor($signed(ym_out)) / scale,
                    $itor($signed(zm_out)) / scale,

                    $itor($signed(xs_out)) / scale,
                    $itor($signed(ys_out)) / scale,
                    $itor($signed(zs_out)) / scale,

                    $itor($signed(w1_out)) / scale,
                    $itor($signed(w2_out)) / scale,
                    $itor($signed(w3_out)) / scale
                );
            end
        end
    end

    // Terminar simulación
    initial begin
        #(SIM_TIME_NS);
        $fclose(fd);
        $finish;
    end

endmodule

//							  `timescale 1ns/1ps
//
//module tb_UDS_RWFONN;
//
//    parameter nbits    = 32;
//    parameter fraccion = 20;
//
//    reg clk;
//    reg rst;
//
//    wire [nbits-1:0] x;
//    wire [nbits-1:0] y;
//    wire [nbits-1:0] z;
//
//    integer fd;
//    integer sample_count;
//
//    // Cambia este valor si quieres guardar menos puntos.
//    // 1 = guarda cada ciclo de reloj.
//    // 10 = guarda cada 10 ciclos.
//    localparam integer SAMPLE_EVERY = 1;
//
//    // Instancia de tu diseño UDS
//    UDS_RWFONN #(
//        .nbits(nbits),
//        .fraccion(fraccion)
//    ) dut (
//        .clk(clk),
//        .rst(rst),
//        .xm_out(xm),
//        .ym_out(ym),
//        .zm_out(zm),
//        .xs_out(xs),
//        .ys_out(ys),
//        .zs_out(zs),
//        .w1_out(w1),
//        .w2_out(w2),
//        .w3_out(w3)
//    );
//
//    // Generador de reloj
//    // Periodo = 20 ns
//    initial begin
//        clk = 1'b0;
//        forever #10 clk = ~clk;
//    end
//
//    // Reset
//    // Este esquema asume reset activo en 0:
//    // rst = 0 reinicia, rst = 1 permite operar.
//    initial begin
//        rst = 1'b0;
//        #100;
//        rst = 1'b1;
//    end
//
//    // Abrir archivo CSV
//    initial begin
//        fd = $fopen("C:/My_Designs/lorenz_export.csv", "w");
//
//        if (fd == 0) begin
//            $display("ERROR: no se pudo abrir el archivo CSV.");
//            $finish;
//        end
//
//        $fdisplay(fd, "time_ns,x_hex,y_hex,z_hex,x_real,y_real,z_real");
//        sample_count = 0;
//    end
//
//    // Exportar datos en cada flanco positivo de reloj
//    always @(posedge clk) begin
//        if (rst) begin
//            sample_count = sample_count + 1;
//
//            if ((sample_count % SAMPLE_EVERY) == 0) begin
//                $fdisplay(
//                    fd,
//                    "%0t,%08h,%08h,%08h,%f,%f,%f",
//                    $time,
//                    x,
//                    y,
//                    z,
//                    $itor($signed(x)) / 1048576.0,
//                    $itor($signed(y)) / 1048576.0,
//                    $itor($signed(z)) / 1048576.0
//                );
//            end
//        end
//    end
//
//    // Terminar simulación
//    initial begin
//        #1000000;   // 1 ms si timescale es 1ns/1ps
//        $fclose(fd);
//        $finish;
//    end
//
//endmodule