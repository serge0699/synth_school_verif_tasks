    // AXI4 master
    
    class axi4_master_driver_base;

        // Interface

        virtual axi4_intf vif;

        // Config

        axi4_cfg_base cfg;

        // Mailbox for generator connection

        mailbox#(axi4_packet_base) gen2drv;

        // Transactions

        mailbox#(axi4_packet_base) q_aw;
        mailbox#(axi4_packet_base) q_w;
        mailbox#(axi4_packet_base) q_ar;

        // Transactions counter

        int unsigned trans_cnt;

        // New

        function new();
            q_aw = new();
            q_w  = new();
            q_ar = new();
        endfunction

        // Main run method

        virtual task run();
            axi4_packet_base p;
            reset_master();
            wait(vif.aresetn);
            forever begin
                fork
                    forever begin
                        drive_master();
                    end
                join_none
                wait(~vif.aresetn);
                disable fork;
                reset_master();
                wait(vif.aresetn);
            end
        endtask

        // Reset all control signals

        virtual task reset_master();
            vif.awvalid <= 0;
            vif.wvalid  <= 0;
            vif.bready  <= 0;
            vif.arvalid <= 0;
            vif.rready  <= 0;
        endtask

        // Drive all channels independently

        virtual task drive_master();
            axi4_packet_base p, p_aw, p_w, p_ar;
            fork
                forever begin
                    // Get transaction from generator
                    // and put to the specific queue
                    gen2drv.get(p);
                    case(p.channel)
                        AW     : q_aw.put(p);
                        W      : q_w.put(p);
                        AR     : q_ar.put(p);
                        default: ;
                    endcase
                end
                forever begin
                    // Execute adress write
                    q_aw.get(p_aw); do_aw(p_aw);

                end
                forever begin
                    // Execute data write
                    q_w.get(p_w); do_w(p_w);
                end
                forever begin
                    // Execute address read
                    q_ar.get(p_ar); do_ar(p_ar);
                end
                forever begin
                    // Execute write response
                    do_b(); trans_cnt += 1;
                end
                forever begin
                    // Execute read response
                    do_r(); trans_cnt += 1;
                end
            join
        endtask

        // Does delay in cycles

        virtual task do_delay();
            int delay;
            void'(std::randomize(delay) with {delay inside {
                [cfg.master_delay_min:cfg.master_delay_max]};});
            repeat(delay) @(posedge vif.clk);
        endtask

        // Set write address signals

        virtual task do_aw(axi4_packet_base p);
            do_delay();
            // Set valid and address
            vif.awvalid <= 1;
            vif.awaddr  <= p.awaddr;
            // Wait for ready
            do begin
                @(posedge vif.clk);
            end
            while( !vif.awready );
            // Drop valid
            vif.awvalid <= 0;
        endtask

        // Set write data signals

        virtual task do_w(axi4_packet_base p);
            do_delay();
            // Set valid and address
            vif.wvalid <= 1;
            vif.wdata  <= p.wdata;
            // Wait for ready
            do begin
                @(posedge vif.clk);
            end
            while( !vif.wready );
            // Drop valid
            vif.wvalid <= 0;
        endtask

        // Set read address signals

        virtual task do_ar(axi4_packet_base p);
            do_delay();
            // Set valid and address
            vif.arvalid <= 1;
            vif.araddr  <= p.araddr;
            vif.arid    <= p.arid;
            // Wait for ready
            do begin
                @(posedge vif.clk);
            end
            while( !vif.arready );
            // Drop valid
            vif.arvalid <= 0;
        endtask

        // Set write response signals

        virtual task do_b();
            do_delay();
            // Set ready and address
            vif.bready <= 1;
            // Wait for valid
            do begin
                @(posedge vif.clk);
            end
            while( !vif.bvalid );
            // Drop ready
            vif.bready <= 0;
        endtask

        // Set read data signals

        virtual task do_r();
            do_delay();
            // Set ready and address
            vif.rready <= 1;
            // Wait for valid
            do begin
                @(posedge vif.clk);
            end
            while( !vif.rvalid );
            // Drop ready
            vif.rready <= 0;
        endtask


    endclass
