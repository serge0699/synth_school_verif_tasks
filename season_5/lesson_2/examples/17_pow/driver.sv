    // Master
    
    class master_driver_base;

        virtual axis_intf vif;

        mailbox#(packet) gen2drv;

        virtual task run();
            packet p;
            forever begin
                @(posedge vif.clk);
                fork
                    forever begin
                        gen2drv.get(p);
                        drive_master(p);
                    end
                join_none
                wait(~vif.aresetn);
                disable fork;
                reset_master();
                wait(vif.aresetn);
            end
        endtask

        virtual task reset_master();
            vif.tvalid <= 0;
            vif.tdata  <= 0;
            vif.tid    <= 0;
        endtask

        virtual task drive_master(packet p);
            repeat(p.delay) @(posedge vif.clk);
            vif.tvalid <= 1;
            vif.tdata  <= p.tdata;
            vif.tid    <= p.tdata;
            vif.tlast  <= p.tlast;
            do begin
                @(posedge vif.clk);
            end
            while(~vif.tready);
            vif.tvalid <= 0;
            vif.tlast  <= 0;
        endtask

    endclass

    // Slave

    class slave_driver_base;

        virtual axis_intf vif;

        test_cfg_base cfg;

        virtual task run();
            forever begin
                @(posedge vif.clk);
                fork
                    forever begin
                        drive_slave();
                    end
                join_none
                wait(~vif.aresetn);
                disable fork;
                reset_slave();
                wait(vif.aresetn);
            end
        endtask
        
        virtual task reset_slave();
            vif.tready <= 0;
        endtask

        virtual task drive_slave();
            int delay;
            void'(std::randomize(delay) with {delay inside {
                [cfg.slave_delay_min:cfg.slave_delay_max]};});
            repeat(delay) @(posedge vif.clk);
            vif.tready <= 1;
            @(posedge vif.clk);
            vif.tready <= 0;
        endtask

    endclass