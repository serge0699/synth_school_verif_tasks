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
    logic        s_tid;
    logic        s_tlast;

    logic        m_tvalid;
    logic        m_tready;
    logic [31:0] m_tdata;
    logic        m_tid;
    logic        m_tlast;


    //---------------------------------
    // Модуль для тестирования
    //---------------------------------

    pow DUT(
        .clk      ( clk       ),
        .aresetn  ( aresetn   ),
        .s_tvalid ( s_tvalid  ),
        .s_tready ( s_tready  ),
        .s_tdata  ( s_tdata   ),
        .s_tid    ( s_tid     ),
        .s_tlast  ( s_tlast   ),
        .m_tvalid ( m_tvalid  ),
        .m_tready ( m_tready  ),
        .m_tdata  ( m_tdata   ),
        .m_tid    ( m_tid     ),
        .m_tlast  ( m_tlast   )
    );


    //---------------------------------
    // Переменные тестирования
    //---------------------------------

    // Период тактового сигнала
    parameter CLK_PERIOD = 10;

    // Пакет и mailbox'ы
    typedef struct {
        logic [31:0] tdata;
        logic        tid;
        logic        tlast;
    } packet;

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
    task timeout();
        repeat(100000) @(posedge clk);
        $stop();
    endtask

    // Генерация входных воздействий
    task reset_master();
        wait(~aresetn);
        s_tvalid <= 0;
        s_tdata  <= 0;
        s_tid    <= 0;
        wait(aresetn);
    endtask

    task drive_master_packet(int size = 1);
        for(int i = 0; i < size; i = i + 1) begin
            if( i == size - 1 ) begin
                drive_master($urandom_range(0, 10), 1);
            end
            else begin
                drive_master($urandom_range(0, 10), 0);
            end
        end
    endtask

    task drive_master(int delay = 0, bit is_last = 0);
        repeat(delay) @(posedge clk);
        s_tvalid <= 1;
        s_tdata  <= $urandom();
        s_tid    <= $urandom();
        s_tlast  <= is_last;
        do begin
            @(posedge clk);
        end
        while(~s_tready);
        s_tvalid <= 0;
        s_tlast  <= 0;
    endtask

    task reset_slave();
        wait(~aresetn);
        m_tready <= 0;
        wait(aresetn);
    endtask

    task drive_slave(int delay = 0);
        repeat(delay) @(posedge clk);
        m_tready <= 1;
        @(posedge clk);
        m_tready <= 0;
    endtask

    // Мониторинг входов
    task monitor_master();
        packet p;
        @(posedge clk);
        if( s_tvalid & s_tready ) begin
            p.tdata  = s_tdata;
            p.tid    = s_tid;
            p.tlast  = s_tlast;
            in_mbx.put(p);
        end
    endtask

    // Мониторинг выходов
    task monitor_slave();
        packet p;
        @(posedge clk);
        if( m_tvalid & m_tready ) begin
            p.tdata  = m_tdata;
            p.tid    = m_tid;
            p.tlast  = m_tlast;
            out_mbx.put(p);
        end
    endtask

    // Проверка
    task check();
        packet in_p, out_p;
        in_mbx.get(in_p);
        out_mbx.get(out_p);
        if( in_p.tid !== out_p.tid ) begin
            $error("%0t Invalid TID: Real: %h, Expected: %h",
                $time(), out_p.tid, in_p.tid);
        end
        if( out_p.tdata !== in_p.tdata ** 5 ) begin
            $error("%0t Invalid TDATA: Real: %0d, Expected: %0d ^ 5 = %0d",
                $time(), out_p.tdata, in_p.tdata, in_p.tdata ** 5);
        end

        if( in_p.tlast !== out_p.tlast ) begin
            $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                $time(), out_p.tlast, in_p.tlast);
        end
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

    // Сброс
    initial begin
        reset();
    end

    // Входные сигналы
    initial begin
        reset_master();
        @(posedge clk);
        repeat(1000) begin
            drive_master_packet($urandom_range(1, 10));
        end
        $stop();
    end

    initial begin
        reset_slave();
        @(posedge clk);
        forever begin
            drive_slave($urandom_range(0, 10));
        end
    end

    // Мониторинг
    initial begin
        wait(aresetn);
        forever begin
            monitor_master();
        end
    end

    initial begin
        wait(aresetn);
        forever begin
            monitor_slave();
        end
    end

    // Проверка
    initial begin
        forever begin
            check();
        end
    end

    // Таймаут
    initial begin
        timeout();
    end

endmodule
