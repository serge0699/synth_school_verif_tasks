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