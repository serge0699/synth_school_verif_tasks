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
    class packet;
        rand int          delay;
        rand logic [31:0] tdata;
        rand logic        tid;
        rand logic        tlast;
    endclass

    class small_data_packet extends packet;
        constraint tdata_c {tdata inside {[0:256]};}
    endclass


    //---------------------------------
    // Общие методы
    //---------------------------------

    // Генерация сигнала сброса
    task reset();
        aresetn <= 0;
        #(10*CLK_PERIOD);
        aresetn <= 1;
    endtask


    //---------------------------------
    // Компоненты
    //---------------------------------

    // Конфигурация тестового сценария

    class test_cfg_base;

        rand int master_pkt_amount    = 100;
        rand int master_size_min      = 1;
        rand int master_size_max      = 10;
        rand int master_delay_min     = 0;
        rand int master_delay_max     = 10;
        rand int slave_delay_min      = 0;
        rand int slave_delay_max      = 10;
             int test_timeout_cycles  = 10000000;

        constraint gen_pkt_amount_c {
            master_pkt_amount inside {[100:500]};
        }

        constraint gen_size_c {
            master_size_min inside {[1:50]};
            master_size_max inside {[1:500]};
            master_size_max >= master_size_min;
        }

        constraint master_delay_c {
            master_delay_min inside {[0:20]};
            master_delay_max inside {[0:20]};
            master_delay_max >= master_delay_min;
        }

        constraint slave_delay_c {
            slave_delay_min inside {[0:20]};
            slave_delay_max inside {[0:20]};
            slave_delay_max >= slave_delay_min;
        }

        function void post_randomize();
            string str;
            str = {str, $sformatf("master_pkt_amount  : %0d\n", master_pkt_amount  )};
            str = {str, $sformatf("master_size_min    : %0d\n", master_size_min    )};
            str = {str, $sformatf("master_size_max    : %0d\n", master_size_max    )};
            str = {str, $sformatf("master_delay_min   : %0d\n", master_delay_min   )};
            str = {str, $sformatf("master_delay_max   : %0d\n", master_delay_max   )};
            str = {str, $sformatf("slave_delay_min    : %0d\n", slave_delay_min    )};
            str = {str, $sformatf("slave_delay_max    : %0d\n", slave_delay_max    )};
            str = {str, $sformatf("test_timeout_cycles: %0d\n", test_timeout_cycles)};
            $display(str);
        endfunction

    endclass

    // Master

    class master_gen_base;

        test_cfg_base cfg;

        mailbox#(packet) gen2drv;

        virtual task run();
            repeat(cfg.master_pkt_amount) begin
                gen_master();
            end
        endtask

        virtual task gen_master();
            packet p;
            int size;
            void'(std::randomize(size) with {size inside {
                [cfg.master_size_min:cfg.master_size_max]};});
            for(int i = 0; i < size; i = i + 1) begin
                p = create_packet();
                if( !p.randomize() with {
                    p.delay inside {[cfg.master_delay_min:cfg.master_delay_max]};
                    p.tlast == (i == size - 1);
                } ) begin
                    $error("Can't randomize packet!");
                    $finish();
                end
                gen2drv.put(p);
            end
        endtask

        virtual function packet create_packet();
            packet p;
            p = new();
            return p;
        endfunction

    endclass

    class master_monitor_base;

        mailbox#(packet) in_mbx;

        virtual task run();
            forever begin
                wait(aresetn);
                fork
                    forever begin
                        monitor_master();
                    end
                join_none
                wait(~aresetn);
                disable fork;
            end
        endtask

        virtual task monitor_master();
            packet p;
            @(posedge clk);
            if( s_tvalid & s_tready ) begin
                p = new();
                p.tdata  = s_tdata;
                p.tid    = s_tid;
                p.tlast  = s_tlast;
                in_mbx.put(p);
            end
        endtask

    endclass

    class master_driver_base;

        mailbox#(packet) gen2drv;
        
        virtual task run();
            packet p;
            forever begin
                @(posedge clk);
                fork
                    forever begin
                        gen2drv.get(p);
                        drive_master(p);
                    end
                join_none
                wait(~aresetn);
                disable fork;
                reset_master();
                wait(aresetn);
            end
        endtask

        virtual task reset_master();
            s_tvalid <= 0;
            s_tdata  <= 0;
            s_tid    <= 0;
        endtask

        virtual task drive_master(packet p);
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

    endclass

    class master_agent_base;

        master_gen_base     master_gen;
        master_monitor_base master_monitor;
        master_driver_base  master_driver;

        function new();
            master_gen     = new();
            master_monitor = new();
            master_driver  = new();
        endfunction

        virtual task run();
            fork
                master_gen    .run();
                master_driver .run();
                master_monitor.run();
            join
        endtask

    endclass

    // Slave

    class slave_monitor_base;

        mailbox#(packet) out_mbx;
        
        virtual task run();
            forever begin
                wait(aresetn);
                fork
                    forever begin
                        monitor_slave();
                    end
                join_none
                wait(~aresetn);
                disable fork;
            end
        endtask

        virtual task monitor_slave();
            packet p;
            @(posedge clk);
            if( m_tvalid & m_tready ) begin
                p = new();
                p.tdata  = m_tdata;
                p.tid    = m_tid;
                p.tlast  = m_tlast;
                out_mbx.put(p);
            end
        endtask

    endclass

    class slave_driver_base;

        test_cfg_base cfg;

        virtual task run();
            forever begin
                @(posedge clk);
                fork
                    forever begin
                        drive_slave();
                    end
                join_none
                wait(~aresetn);
                disable fork;
                reset_slave();
                wait(aresetn);
            end
        endtask

        virtual task reset_slave();
            m_tready <= 0;
        endtask

        virtual task drive_slave();
            int delay;
            void'(std::randomize(delay) with {delay inside {
                [cfg.slave_delay_min:cfg.slave_delay_max]};});
            repeat(delay) @(posedge clk);
            m_tready <= 1;
            @(posedge clk);
            m_tready <= 0;
        endtask

    endclass

    class slave_agent_base;

        slave_monitor_base slave_monitor;
        slave_driver_base  slave_driver;

        function new();
            slave_monitor = new();
            slave_driver  = new();
        endfunction

        virtual task run();
            fork
                slave_driver .run();
                slave_monitor.run();
            join
        endtask

    endclass

    // Checker

    class checker_base;

        test_cfg_base cfg;

        bit done;

        mailbox#(packet) in_mbx;
        mailbox#(packet) out_mbx;
        
        virtual task run();
            do_check();
        endtask

        virtual task check(packet in, packet out);
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

        virtual task do_check();
            int cnt;
            packet in_p, out_p;
            forever begin
                wait(aresetn);
                fork
                    forever begin
                        in_mbx.get(in_p);
                        out_mbx.get(out_p);
                        check(in_p, out_p);
                        cnt = cnt + out_p.tlast;
                        if( cnt == cfg.master_pkt_amount ) begin
                            break;
                        end
                    end
                    begin
                        wait(~aresetn);
                    end
                join_any
                disable fork;
                // Если достигли нужного количества пакетов,
                // то выходим из бесконечного цикла и выставляем
                // флаг завершения
                if( cnt == cfg.master_pkt_amount ) begin
                    done = 1;
                    break;
                end
                // Иначе пришел сигнал сброса. Очищаем mailbox
                // от входящих транзакций, т.к все они будут
                // "выкинуты" из конвейера при приходе сигнала сброса
                while(in_mbx.try_get(in_p)) cnt = cnt + 1;
            end
        endtask

    endclass

    // Окружение

    class env_base;

        master_agent_base master;
        slave_agent_base  slave;
        checker_base      check;

        function new();
            master  = new();
            slave   = new();
            check   = new();
        endfunction

        virtual task run();
            fork
                master.run();
                slave .run();
                check .run();
            join
        endtask

    endclass


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

    class test_base;

        test_cfg_base cfg;

        env_base env;

        mailbox#(packet) gen2drv;
        mailbox#(packet) in_mbx;
        mailbox#(packet) out_mbx;

        function new();
            // Создание
            cfg = new();
            env = new();
            gen2drv = new();
            in_mbx  = new();
            out_mbx = new();
            // Конфигурация
            if( !cfg.randomize() ) begin
                $error("Can't randomize test configuration!");
                $finish();
            end
            env.master.master_gen.cfg = cfg;
            env.slave.slave_driver.cfg = cfg;
            env.check.cfg = cfg;
            // Подключение
            env.master.master_gen.gen2drv    = gen2drv;
            env.master.master_driver.gen2drv = gen2drv;
            env.master.master_monitor.in_mbx = in_mbx;
            env.slave.slave_monitor.out_mbx  = out_mbx;
            env.check.in_mbx                 = in_mbx;
            env.check.out_mbx                = out_mbx;
        endfunction

        virtual task run();
            bit done;
            fork
                env.run();
                timeout();
            join_none
            wait(env.check.done);
            $display("Test was finished!");
            $finish();
        endtask

        // Таймаут теста
        task timeout();
            repeat(cfg.test_timeout_cycles) @(posedge clk);
            $error("Test timeout!");
            $finish();
        endtask

    endclass

    initial begin
        test_base test;
        test = new();
        fork
            reset();
            test.run();
        join_none
        repeat(100) @(posedge clk);
        // Сброс в середине теста
        reset();
    end

endmodule
