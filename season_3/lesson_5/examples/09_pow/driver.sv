    // Master
    
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

    // Slave

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
