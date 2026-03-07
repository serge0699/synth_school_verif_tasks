    class test_base;

        virtual axis_intf vif_master;
        virtual axis_intf vif_slave;

        test_cfg_base cfg;

        env_base env;

        mailbox#(packet) gen2drv;
        mailbox#(packet) in_mbx;
        mailbox#(packet) out_mbx;

        function new (
            virtual axis_intf vif_master,
            virtual axis_intf vif_slave
        );
            // Получение интерфейсов
            this.vif_master = vif_master;
            this.vif_slave  = vif_slave;
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
            env.master.master_gen.cfg    = cfg;
            env.master.master_driver.cfg = cfg;
            env.slave.slave_driver.cfg   = cfg;
            env.check.cfg                = cfg;
            // Подключение
            env.master.master_gen.gen2drv    = gen2drv;
            env.master.master_driver.gen2drv = gen2drv;
            env.master.master_monitor.in_mbx = in_mbx;
            env.slave.slave_monitor.out_mbx  = out_mbx;
            env.check.in_mbx                 = in_mbx;
            env.check.out_mbx                = out_mbx;
            // Проброс интерфейса
            env.master.master_driver.vif  = this.vif_master;
            env.master.master_monitor.vif = this.vif_master;
            env.slave.slave_driver.vif    = this.vif_slave;
            env.slave.slave_monitor.vif   = this.vif_slave;
        endfunction

        virtual task run();
            bit done;
            fork
                env.run();
                reset_checker();
                timeout();
            join_none
            wait(env.check.done);
            $display("Test was finished!");
            $finish();
        endtask

        // Сброс проверки
        virtual task reset_checker();
            forever begin
                wait(~vif_master.aresetn);
                env.check.in_reset = 1;
                wait(vif_master.aresetn);
                env.check.in_reset = 0;
            end
        endtask

        // Таймаут теста
        task timeout();
            repeat(cfg.test_timeout_cycles) @(posedge vif_master.clk);
            $error("Test timeout!");
            $finish();
        endtask

    endclass