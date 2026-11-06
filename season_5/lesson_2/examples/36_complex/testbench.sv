`timescale 1ns/1ps

module testbench;

    //---------------------------------
    // Импорт паккейджа тестирования
    //---------------------------------

    import test_complex_pkg::*;


    //---------------------------------
    // Сигналы
    //---------------------------------

    logic        clk;
    logic        aresetn;


    //---------------------------------
    // Интерфейс
    //---------------------------------

    axis_intf intf1_master (clk, aresetn);
    axis_intf intf1_slave  (clk, aresetn);
    axis_intf intf2_master (clk, aresetn);
    axis_intf intf2_slave  (clk, aresetn);


    //---------------------------------
    // Модуль для тестирования
    //---------------------------------

    complex DUT(
        .clk       ( clk                  ),
        .aresetn   ( aresetn              ),
        .s1_tvalid ( intf1_master.tvalid  ),
        .s1_tready ( intf1_master.tready  ),
        .s1_tdata  ( intf1_master.tdata   ),
        .s1_tid    ( intf1_master.tid     ),
        .s1_tlast  ( intf1_master.tlast   ),
        .m1_tvalid ( intf1_slave.tvalid   ),
        .m1_tready ( intf1_slave.tready   ),
        .m1_tdata  ( intf1_slave.tdata    ),
        .m1_tid    ( intf1_slave.tid      ),
        .m1_tlast  ( intf1_slave.tlast    ),
        .s2_tvalid ( intf2_master.tvalid  ),
        .s2_tready ( intf2_master.tready  ),
        .s2_tdata  ( intf2_master.tdata   ),
        .s2_tid    ( intf2_master.tid     ),
        .s2_tlast  ( intf2_master.tlast   ),
        .m2_tvalid ( intf2_slave.tvalid   ),
        .m2_tready ( intf2_slave.tready   ),
        .m2_tdata  ( intf2_slave.tdata    ),
        .m2_tid    ( intf2_slave.tid      ),
        .m2_tlast  ( intf2_slave.tlast    )
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
        test_complex_base test;
        test = new(intf1_master, intf1_slave,
                   intf2_master, intf2_slave);
        fork
            reset();
            test.run();
        join_none
        repeat(1000) @(posedge clk);
        // Сброс в середине теста
        reset();
    end

endmodule
