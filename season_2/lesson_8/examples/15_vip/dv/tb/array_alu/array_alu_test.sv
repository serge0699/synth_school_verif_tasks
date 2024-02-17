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

    class array_alu_pre_work_mode_test extends array_alu_test_base;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            super.new(axi4_vif, apb_vif);
        endfunction

        virtual task run();

            // Настройка дизайна по APB
            array_alu_apb_work_mode_gen apb_work_mode_gen = new();

            // Запись массивов по AXI4
            array_alu_axi4_work_mode_gen axi4_work_mode_gen = new();

            // Подключение "сценариев" к драйверам
            apb_work_mode_gen.gen2drv = apb_gen2drv;
            axi4_work_mode_gen.gen2drv = axi4_gen2drv;

            // Реализация тестового сценария
            fork
                fork
                    env.run();
                    // Совместное воздействие по APB и AXI4
                    apb_work_mode_gen.run();
                    axi4_work_mode_gen.run();
                join
                reset_checker();
                timeout();
            join_any
            $display("Test was finished!");
            $finish();

        endtask

    endclass

    class array_alu_work_mode_test extends array_alu_test_base;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            super.new(axi4_vif, apb_vif);
        endfunction

        virtual task run();
    
            // Настройка дизайна по APB
            array_alu_apb_work_mode_gen apb_work_mode_gen = new();

            // Запись массивов по AXI4
            array_alu_axi4_work_mode_gen axi4_work_mode_gen = new();

            // Подключение "сценариев" к драйверам
            apb_work_mode_gen.gen2drv = apb_gen2drv;
            axi4_work_mode_gen.gen2drv = axi4_gen2drv;

            // Реализация тестового сценария
            fork
                fork
                    env.run();
                    // Последовательные воздействия
                    begin
                        // Запись массивов по AXI4
                        axi4_work_mode_gen.run();
                        // Ожидание того, что все транзакции будут переданы по AXI4
                        wait( env.axi4_env.master.master_driver.trans_cnt
                            == axi4_work_mode_gen.addresses.size() );
                        // Теперь конфигурируем операцию и запускаем работу
                        apb_work_mode_gen.run();
                    end
                join
                reset_checker();
                timeout();
            join_any
            $display("Test was finished!");
            $finish();
        endtask

    endclass

    class array_alu_work_mode_resp_test extends array_alu_test_base;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            array_alu_apb_work_mode_resp_driver apb_work_mode_resp_driver;
            super.new(axi4_vif, apb_vif);
            // Замена драйвера на драйвер с обратной связью
            apb_work_mode_resp_driver = new(); 
            env.apb_env.master.master_driver = apb_work_mode_resp_driver;
            // Настройка нового драйвера
            env.apb_env.master.master_driver.cfg = cfg.apb_cfg;
            env.apb_env.master.master_driver.gen2drv = apb_gen2drv;
            env.apb_env.master.master_driver.vif = apb_vif;
        endfunction

        virtual task run();

            // Настройка дизайна по APB
            array_alu_apb_work_mode_gen apb_work_mode_gen = new();

            // Запись массивов по AXI4
            array_alu_axi4_work_mode_gen axi4_work_mode_gen = new();

            // Чтение DONE, пока не будет равен 1
            array_alu_apb_work_mode_resp_gen  apb_master_resp_gen = new();

            // Вычитывание результата оп AXI4
            array_alu_axi4_work_mode_resp_gen axi4_master_resp_gen = new();

            // Подключение "сценариев" к драйверам
            apb_work_mode_gen.gen2drv    = apb_gen2drv;
            axi4_work_mode_gen.gen2drv   = axi4_gen2drv;
            apb_master_resp_gen.gen2drv  = apb_gen2drv;
            axi4_master_resp_gen.gen2drv = axi4_gen2drv;

            // Реализация тестового сценария
            fork
                fork
                    env.run();
                    // Последовательные воздействия
                    begin
                        // Запись массивов по AXI4
                        axi4_work_mode_gen.run();
                        // Ожидание того, что все транзакции будут переданы по AXI4
                        wait( env.axi4_env.master.master_driver.trans_cnt
                            == axi4_work_mode_gen.addresses.size() );
                        // Теперь конфигурируем операцию и запускаем работу
                        apb_work_mode_gen.run();
                        // Ждем, пока дизайн сконфигурируется
                        wait( env.apb_env.master.master_driver.trans_cnt == 2 );
                        // Читаем DONE, пока он не равен 1 
                        apb_master_resp_gen.run();
                        // Читаем результат по AXI4
                        axi4_master_resp_gen.run();
                    end
                join
                reset_checker();
                timeout();
            join_any
            $display("Test was finished!");
            $finish();
        endtask

    endclass

    class array_alu_work_mode_resp_check_test extends array_alu_work_mode_resp_test;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            mailbox#(apb_packet_base) apb_mbx;
            array_alu_axi4_checker_base array_alu_axi4_check;
            super.new(axi4_vif, apb_vif);
            // Замена чекера на кастомный
            array_alu_axi4_check = new();
            env.axi4_env.check = array_alu_axi4_check;
            // Переподключение AXI4
            array_alu_axi4_check.mbx = env.axi4_env.master.master_monitor.mbx;
            // Переподключение APB
            apb_mbx = new();
            array_alu_axi4_check.apb_mbx = apb_mbx;
            env.apb_env.master.master_monitor.mbx = apb_mbx;
        endfunction

    endclass

    
    class array_alu_work_mode_resp_check_multiple_test extends array_alu_work_mode_resp_check_test;

        function new (
            virtual axi4_intf axi4_vif,
            virtual apb_intf  apb_vif
        );
            super.new(axi4_vif, apb_vif);
        endfunction

        virtual task run();

            // Реализация тестового сценария
            fork
                fork
                    env.run();
                    // Последовательные воздействия
                    begin
                        work_mode();
                    end
                join
                reset_checker();
                timeout();
            join_any
            $display("Test was finished!");
            $finish();
        endtask

        virtual task work_mode();
            // Настройка дизайна по APB
            array_alu_apb_work_mode_gen apb_work_mode_gen = new();
            // Запись массивов по AXI4
            array_alu_axi4_work_mode_gen axi4_work_mode_gen = new();
            // Чтение DONE, пока не будет равен 1
            array_alu_apb_work_mode_resp_gen  apb_master_resp_gen = new();
            // Вычитывание результата оп AXI4
            array_alu_axi4_work_mode_resp_gen axi4_master_resp_gen = new();
            // Подключение "сценариев" к драйверам
            apb_work_mode_gen.gen2drv    = apb_gen2drv;
            axi4_work_mode_gen.gen2drv   = axi4_gen2drv;
            apb_master_resp_gen.gen2drv  = apb_gen2drv;
            axi4_master_resp_gen.gen2drv = axi4_gen2drv;
            // Запись массивов по AXI4
            axi4_work_mode_gen.run();
            // Ожидание того, что все транзакции будут переданы по AXI4
            wait( env.axi4_env.master.master_driver.trans_cnt
                == axi4_work_mode_gen.addresses.size() );
            env.axi4_env.master.master_driver.trans_cnt = 0;
            // Теперь конфигурируем операцию и запускаем работу
            apb_work_mode_gen.run();
            // Ждем, пока дизайн сконфигурируется
            wait( env.apb_env.master.master_driver.trans_cnt == 2 );
            env.apb_env.master.master_driver.trans_cnt = 0;
            // Читаем DONE, пока он не равен 1 
            apb_master_resp_gen.run();
            // Читаем результат по AXI4
            axi4_master_resp_gen.run();
            // Ожидание того, что все транзакции будут переданы по AXI4
            wait( env.axi4_env.master.master_driver.trans_cnt
                == axi4_master_resp_gen.addresses.size() );
            env.axi4_env.master.master_driver.trans_cnt = 0;
        endtask

    endclass
