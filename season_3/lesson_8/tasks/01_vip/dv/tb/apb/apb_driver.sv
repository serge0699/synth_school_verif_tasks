    // APB master
    
    class apb_master_driver_base;

        // Interface

        virtual apb_intf vif;

        // Config

        apb_cfg_base cfg;

        // Mailbox for generator connection

        mailbox#(apb_packet_base) gen2drv;

        // Transactions counter

        int unsigned trans_cnt;

        // Main run

        virtual task run();
            apb_packet_base p;
            reset_master();
            wait(vif.aresetn);
            forever begin
                fork
                    forever begin
                        gen2drv.get(p);
                        drive_master(p);
                        trans_cnt += 1;
                    end
                join_none
                wait(~vif.aresetn);
                disable fork;
                reset_master();
                wait(vif.aresetn);
            end
        endtask

        virtual task reset_master();
            vif.psel    <= 0;
            vif.penable <= 0;
        endtask

        virtual task drive_master(apb_packet_base p);
            // TODO: реализуйте отправку пакета по APB
            // Стадии:
            //   1) Подождите количество тактов в диапазоне
            //      [cfg.master_delay_min:cfg.master_delay_max]
            //   2) Выставите vif.psel = 1, а также информационные
            //      сигналы
            //   3) Подождите 1 такт и выставите vif.penable = 1
            //   4) Ждите такты, пока vif.pready != 1
            //   5) Сбросьте vif.psel и vif.penable в 0
        endtask

    endclass
