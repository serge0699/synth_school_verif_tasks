`timescale 1ns/1ps

module testbench;


    // Сигналы
    logic        clk;
    logic        aresetn;

    logic        s_tvalid;
    logic        s_tready;
    logic [31:0] s_tdata;
    logic        s_tid;

    logic        m_tvalid;
    logic        m_tready;
    logic [31:0] m_tdata;
    logic        m_tid;


    // Модуль для тестирования
    pow DUT(
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


    // Период тактового сигнала
    parameter CLK_PERIOD = 10;


    // Генерация тактового сигнала
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end


    // Генерация сигнала сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end


    // Генерация входных воздействий
    initial begin
        wait(~aresetn);
        s_tvalid <= 0;
        s_tdata  <= 0;
        s_tid    <= 0;
        wait(aresetn);
        repeat(1000) begin
            @(posedge clk);
            s_tvalid <= 1;
            s_tdata  <= $urandom();
            s_tid    <= $urandom();
            do begin
                @(posedge clk);
            end
            while(~s_tready);
            s_tvalid <= 0;
        end
        $stop();
    end

    initial begin
        wait(~aresetn);
        m_tready <= 0;
        wait(aresetn);
        forever begin
            @(posedge clk);
            m_tready <= $urandom();
        end
    end


    // Пакет и mailbox'ы
    typedef struct {
        logic [31:0] tdata;
        logic        tid;
    } packet;

    mailbox#(packet) in_mbx  = new();
    mailbox#(packet) out_mbx = new();


    // Мониторинг входов
    initial begin
        packet p;
        wait(aresetn);
        forever begin
            @(posedge clk);
            if( s_tvalid & s_tready ) begin
                p.tdata  = s_tdata;
                p.tid    = s_tid;
                in_mbx.put(p);
            end
        end
    end


    // Мониторинг выходов
    initial begin
        packet p;
        wait(aresetn);
        forever begin
            @(posedge clk);
            if( m_tvalid & m_tready ) begin
                p.tdata  = m_tdata;
                p.tid    = m_tid;
                out_mbx.put(p);
            end
        end
    end


    // Проверка
    initial begin
        packet in_p, out_p;
        forever begin
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
        end
    end


    // Таймаут
    initial begin
        repeat(100000) @(posedge clk);
        $stop();
    end


endmodule
