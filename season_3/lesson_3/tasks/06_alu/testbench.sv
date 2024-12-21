`timescale 1ns/1ps

module testbench;


    //---------------------------------
    // Сигналы
    //---------------------------------

    logic        clk;
    logic        aresetn;

    logic        s_tvalid;
    logic        s_tready;
    logic [31:0] s_tdata;
    logic [ 1:0] s_tid;

    logic        m_tvalid;
    logic        m_tready;
    logic [31:0] m_tdata;
    logic [ 1:0] m_tid;


    //---------------------------------
    // Модуль для тестирования
    //---------------------------------

    alu DUT(
        .clk      ( clk       ),
        .aresetn  ( aresetn   ),
        .s_tvalid ( s_tvalid  ),
        .s_tready ( s_tready  ),
        .s_tdata  ( s_tdata   ),
        .s_tid    ( s_tid     ),
        .m_tvalid ( m_tvalid  ),
        .m_tready ( m_tready  ),
        .m_tdata  ( m_tdata   ),
        .m_tid    ( m_tid     )
    );


    //---------------------------------
    // Переменные тестирования
    //---------------------------------

    // Период тактового сигнала
    parameter CLK_PERIOD = 10;

    // Пакет и mailbox'ы
    typedef struct {
        rand int          delay;
        rand logic [31:0] tdata;
        rand logic [ 1:0] tid;
    } packet;

    mailbox#(packet) gen2drv = new();
    mailbox#(packet) in_mbx  = new();
    mailbox#(packet) out_mbx = new();


    //---------------------------------
    // Методы
    //---------------------------------

    // Генерация сигнала сброса
    task reset();
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    endtask

    // Таймаут теста
    task timeout(int timeout_cycles = 100000);
        repeat(timeout_cycles) @(posedge clk);
        $stop();
    endtask

    // TODO:
    // Реализуйте тестовое окружение для проверки ALU.
    // Рекомендуется использовать подход, основанный
    // на задачах и разделении master/slave. В качестве
    // примера может выступать ../examples/13_pow/.
    //
    // Обратите внимание, что существует 5 версий дизайна,
    // которые выбираются при запуске симуляции следующим
    // образом:
    //   make <аргумента> COMP_OPTS=+define+VERSION_<номер-версии>
    //
    // Полное описание работы ALU находится в файле alu.svp


endmodule
