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
            int delay;
            void'(std::randomize(delay) with {delay inside {
                [cfg.master_delay_min:cfg.master_delay_max]};});
            repeat(delay) @(posedge vif.clk);
            // PSEL
            vif.psel    <= 1;
            vif.paddr   <= p.paddr;
            vif.pwrite  <= p.pwrite;
            vif.pwdata  <= p.pwdata;
            @(posedge vif.clk);
            // PENABLE
            vif.penable <= 1;
            do begin
                @(posedge vif.clk);
            end
            while( !vif.pready );
            // Drop PSEL and PENABLE
            vif.psel    <= 0;
            vif.penable <= 0;
        endtask

    endclass
