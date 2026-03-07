package test_complex_pkg;

    import test_pkg::*;

    class checker_mult_base extends checker_base;

        virtual task check(packet in, packet out);
            if( in.tid !== out.tid ) begin
                $error("%0t Invalid TID: Real: %h, Expected: %h",
                    $time(), out.tid, in.tid);
            end
            if( out.tdata !== in.tdata * in.tdata ) begin
                $error("%0t Invalid TDATA: Real: %0d, Expected: %0d * %0d = %0d",
                    $time(), out.tdata, in.tdata, in.tdata, in.tdata * in.tdata);
            end
            if( in.tlast !== out.tlast ) begin
                $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                    $time(), out.tlast, in.tlast);
            end
        endtask

    endclass

    class test_complex_base extends test_base;

        virtual axis_intf vif2_master;
        virtual axis_intf vif2_slave;
        env_base env2;

        mailbox#(packet) gen2drv2;
        mailbox#(packet) in_mbx2;
        mailbox#(packet) out_mbx2;

        function new (
            virtual axis_intf vif1_master,
            virtual axis_intf vif1_slave,
            virtual axis_intf vif2_master,
            virtual axis_intf vif2_slave
        );
            checker_mult_base check_mult;
            super.new(vif1_master, vif1_slave);
            // Получение интерфейсов
            this.vif2_master = vif2_master;
            this.vif2_slave  = vif2_slave;
            // Создание
            env2 = new();
            gen2drv2 = new();
            in_mbx2  = new();
            out_mbx2 = new();
            // Замена чекера
            check_mult = new();
            env2.check = check_mult;
            // Конфигурация
            env2.master.master_gen.cfg    = cfg;
            env2.master.master_driver.cfg = cfg;
            env2.slave.slave_driver.cfg   = cfg;
            env2.check.cfg                = cfg;
            // Подключение
            env2.master.master_gen.gen2drv    = gen2drv2;
            env2.master.master_driver.gen2drv = gen2drv2;
            env2.master.master_monitor.in_mbx = in_mbx2;
            env2.slave.slave_monitor.out_mbx  = out_mbx2;
            env2.check.in_mbx                 = in_mbx2;
            env2.check.out_mbx                = out_mbx2;
            // Проброс интерфейса
            env2.master.master_driver.vif  = this.vif2_master;
            env2.master.master_monitor.vif = this.vif2_master;
            env2.slave.slave_driver.vif    = this.vif2_slave;
            env2.slave.slave_monitor.vif   = this.vif2_slave;
        endfunction

        virtual task run();
            bit done;
            fork
                env.run();
                env2.run();
                reset_checker();
                timeout();
            join_none
            fork
                wait(env.check.done);
                wait(env2.check.done);
            join
            $display("Test was finished!");
            $finish();
        endtask

        virtual task reset_checker();
            fork
                super.reset_checker();
            join_none
            forever begin
                wait(~vif2_master.aresetn);
                env2.check.in_reset = 1;
                wait(vif2_master.aresetn);
                env2.check.in_reset = 0;
            end
        endtask

    endclass

endpackage