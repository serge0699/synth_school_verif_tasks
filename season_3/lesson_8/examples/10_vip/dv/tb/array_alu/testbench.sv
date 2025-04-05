`timescale 1ns/1ps

module testbench;


    //---------------------------------
    // Импорт паккейджа тестирования
    //---------------------------------

    import array_alu_test_pkg::*;


    //---------------------------------
    // Сигналы
    //---------------------------------

    logic        clk;
    logic        aresetn;


    //---------------------------------
    // Интерфейс
    //---------------------------------

    axi4_intf axi4_if (clk, aresetn);
    apb_intf  apb_if  (clk, aresetn);


    //---------------------------------
    // Модуль для тестирования
    //---------------------------------

    array_alu DUT(
        .clk        ( clk             ),
        .aresetn    ( aresetn         ),
        .paddr      ( apb_if.paddr    ),
        .psel       ( apb_if.psel     ),
        .penable    ( apb_if.penable  ),
        .pwrite     ( apb_if.pwrite   ),
        .pwdata     ( apb_if.pwdata   ),
        .pready     ( apb_if.pready   ),
        .prdata     ( apb_if.prdata   ),
        .pslverr    ( apb_if.pslverr  ),
        .awvalid    ( axi4_if.awvalid ),
        .awready    ( axi4_if.awready ),
        .awaddr     ( axi4_if.awaddr  ),
        .wvalid     ( axi4_if.wvalid  ),
        .wready     ( axi4_if.wready  ),
        .wdata      ( axi4_if.wdata   ),
        .bvalid     ( axi4_if.bvalid  ),
        .bresp      ( axi4_if.bresp   ),
        .bready     ( axi4_if.bready  ),
        .arvalid    ( axi4_if.arvalid ),
        .arready    ( axi4_if.arready ),
        .arid       ( axi4_if.arid    ),
        .araddr     ( axi4_if.araddr  ),
        .rvalid     ( axi4_if.rvalid  ),
        .rready     ( axi4_if.rready  ),
        .rid        ( axi4_if.rid     ),
        .rdata      ( axi4_if.rdata   ),
        .rresp      ( axi4_if.rresp   )
    );


    //---------------------------------
    // Переменные тестирования
    //---------------------------------

    // Период тактового сигнала

    parameter CLK_PERIOD = 10;


    //---------------------------------
    // Общие методы
    //---------------------------------

    // Генерация сигнала сброса
    task reset();
        aresetn <= 0;
        #(100*CLK_PERIOD);
        aresetn <= 1;
    endtask


    //---------------------------------
    // Выполнение
    //---------------------------------

    // Генерация тактового сигнала
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    initial begin
        array_alu_pre_work_mode_test test;
        test = new(axi4_if, apb_if);
        fork
            reset();
            test.run();
        join_none
        repeat(1000) @(posedge clk);
        // Сброс в ходе выполнения теста
        reset();
    end


endmodule
