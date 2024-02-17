    class array_alu_test_base;

        // Interfaces

        virtual axi4_intf axi4_vif;
        virtual apb_intf  apb_vif;

        // Main configuration

        array_alu_cfg_base cfg;

        // Environment

        array_alu_env_base env;

        // Mailboxes for connection

        mailbox#(axi4_packet_base) axi4_gen2drv;
        mailbox#(axi4_packet_base) axi4_mon2scb;
        mailbox#(apb_packet_base ) apb_gen2drv;
        mailbox#(apb_packet_base)  apb_mon2scb;


        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            // Получение интерфейсов
            this.axi4_vif = axi4_vif;
            this.apb_vif  = apb_vif;
            // Создание
            cfg           = new();
            env           = new();
            axi4_gen2drv  = new();
            axi4_mon2scb  = new();
            apb_gen2drv   = new();
            apb_mon2scb   = new();
            // Конфигурация
            if( !cfg.randomize() ) begin
                $error("Can't randomize test configuration!");
                $finish();
            end
            env.axi4_env.master.master_gen.cfg        = cfg.axi4_cfg;
            env.axi4_env.master.master_driver.cfg     = cfg.axi4_cfg;
            env.apb_env.master.master_gen.cfg         = cfg.apb_cfg;
            env.apb_env.master.master_driver.cfg      = cfg.apb_cfg;
            // Подключение
            env.axi4_env.master.master_gen.gen2drv    = axi4_gen2drv;
            env.axi4_env.master.master_driver.gen2drv = axi4_gen2drv;
            env.axi4_env.master.master_monitor.mbx    = axi4_mon2scb;
            env.axi4_env.check.mbx                    = axi4_mon2scb;
            env.apb_env.master.master_gen.gen2drv     = apb_gen2drv;
            env.apb_env.master.master_driver.gen2drv  = apb_gen2drv;
            env.apb_env.master.master_monitor.mbx     = apb_mon2scb;
            env.apb_env.check.mbx                     = apb_mon2scb;
            // Проброс интерфейса
            env.axi4_env.master.master_driver.vif     = this.axi4_vif;
            env.axi4_env.master.master_monitor.vif    = this.axi4_vif;
            env.apb_env.master.master_driver.vif      = this.apb_vif;
            env.apb_env.master.master_monitor.vif     = this.apb_vif;
        endfunction

        virtual task run();
            fork
                fork
                    env.run();
                    // Запуск генераторов совместно
                    env.axi4_env.master.master_gen.run();
                    env.apb_env.master.master_gen.run();
                join
                reset_checker();
                timeout();
            join_any
            $display("Test was finished!");
            $finish();
        endtask

        // Сброс проверки
        virtual task reset_checker();
            forever begin
                wait(~axi4_vif.aresetn);
                env.axi4_env.check.in_reset = 1;
                wait(axi4_vif.aresetn);
                env.axi4_env.check.in_reset = 0;
            end
        endtask

        // Таймаут теста
        task timeout();
            repeat(cfg.test_timeout_cycles) @(posedge axi4_vif.clk);
            $error("Test timeout!");
        endtask

    endclass

    class array_alu_apb_vr_test extends array_alu_test_base;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            array_alu_apb_vr_gen vr_gen;
            super.new(axi4_vif, apb_vif);
            // Замена генератора
            vr_gen = new(); 
            env.apb_env.master.master_gen = vr_gen;
            // Настройка генератора
            env.apb_env.master.master_gen.cfg = cfg.apb_cfg;
            env.apb_env.master.master_gen.gen2drv = apb_gen2drv;
        endfunction

    endclass

    class array_alu_apb_vr_va_test extends array_alu_test_base;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            array_alu_apb_vr_va_gen vr_va_gen;
            super.new(axi4_vif, apb_vif);
            // Замена генератора
            vr_va_gen = new(); 
            env.apb_env.master.master_gen = vr_va_gen;
            // Настройка генератора
            env.apb_env.master.master_gen.cfg = cfg.apb_cfg;
            env.apb_env.master.master_gen.gen2drv = apb_gen2drv;
        endfunction

    endclass

    class array_alu_apb_vr_va_vd_test extends array_alu_test_base;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            array_alu_apb_vr_va_vd_gen vr_va_vd_gen;
            super.new(axi4_vif, apb_vif);
            // Замена генератора
            vr_va_vd_gen = new(); 
            env.apb_env.master.master_gen = vr_va_vd_gen;
            // Настройка генератора
            env.apb_env.master.master_gen.cfg = cfg.apb_cfg;
            env.apb_env.master.master_gen.gen2drv = apb_gen2drv;
        endfunction

    endclass

    class array_alu_apb_axi4_valid_test extends array_alu_apb_vr_va_vd_test;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            array_alu_axi4_vr_gen vr_gen;
            super.new(axi4_vif, apb_vif);
            // Замена генератора
            vr_gen = new(); 
            env.axi4_env.master.master_gen = vr_gen;
            // Настройка генератора
            env.axi4_env.master.master_gen.cfg = cfg.axi4_cfg;
            env.axi4_env.master.master_gen.gen2drv = axi4_gen2drv;
        endfunction

    endclass