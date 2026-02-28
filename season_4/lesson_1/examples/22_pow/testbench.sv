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
        rand int          delay;
        rand logic [31:0] tdata;
        rand logic        tid;
        rand logic        tlast;
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
    task timeout();
        repeat(100000) @(posedge clk);
        $stop();
    endtask

    // Master
    task gen_master(int size = 1);
        packet p;
        for(int i = 0; i < size; i = i + 1) begin
            if( !std::randomize(p) with {
                p.delay inside {[0:10]};
                p.tlast == (i == size - 1);
            } ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        end
    endtask

    task do_master_gen();
        repeat(1000) begin
            gen_master($urandom_range(1, 10));
        end
    endtask

    task reset_master();
        wait(~aresetn);
        s_tvalid <= 0;
        s_tdata  <= 0;
        s_tid    <= 0;
        wait(aresetn);
    endtask

    task drive_master(packet p);
        repeat(p.delay) @(posedge clk);
        s_tvalid <= 1;
        s_tdata  <= p.tdata;
        s_tid    <= p.tid;
        s_tlast  <= p.tlast;
        do begin
            @(posedge clk);
        end
        while(~s_tready);
        s_tvalid <= 0;
        s_tlast  <= 0;
    endtask

    task do_master_drive();
        packet p;
        reset_master();
        @(posedge clk);
        forever begin
            gen2drv.get(p);
            drive_master(p);
        end
    endtask

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

    task do_master_monitor();
        wait(aresetn);
        forever begin
            monitor_master();
        end
    endtask

    // Master
    task master();
        fork
            do_master_gen();
            do_master_drive();
            do_master_monitor();
        join
    endtask

    // Slave
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

    task do_slave_drive();
        reset_slave();
        @(posedge clk);
        forever begin
            drive_slave($urandom_range(0, 10));
        end
    endtask

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

    task do_slave_monitor();
        wait(aresetn);
        forever begin
            monitor_slave();
        end
    endtask

    // Slave
    task slave();
        fork
            do_slave_drive();
            do_slave_monitor();
        join
    endtask

    // Проверка
    task check(packet in, packet out);
        if( in.tid !== out.tid ) begin
            $error("%0t Invalid TID: Real: %h, Expected: %h",
                $time(), out.tid, in.tid);
        end
        if( out.tdata !== in.tdata ** 5 ) begin
            $error("%0t Invalid TDATA: Real: %0d, Expected: %0d ^ 5 = %0d",
                $time(), out.tdata, in.tdata, in.tdata ** 5);
        end
        if( in.tlast !== out.tlast ) begin
            $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                $time(), out.tlast, in.tlast);
        end
    endtask

    task do_check();
        int cnt;
        packet in_p, out_p;
        forever begin
            in_mbx.get(in_p);
            out_mbx.get(out_p);
            check(in_p, out_p);
            cnt = cnt + out_p.tlast;
            if( cnt == 1000 ) begin
                break;
            end
        end
        $stop();
    endtask

    task error_checker();
        do_check();
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

    task test();
        fork
            master       ();
            slave        ();
            error_checker();
            timeout      ();
        join
    endtask

    initial begin
        test();
    end

endmodule

