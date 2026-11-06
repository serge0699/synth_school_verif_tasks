    // Master
    
    class master_monitor_base;

        virtual axis_intf vif;

        mailbox#(packet) in_mbx;

        virtual task run();
            forever begin
                wait(vif.aresetn);
                fork
                    forever begin
                        monitor_master();
                    end
                join_none
                wait(~vif.aresetn);
                disable fork;
            end
        endtask

        virtual task monitor_master();
            packet p;
            @(posedge vif.clk);
            if( vif.tvalid & vif.tready ) begin
                p = new();
                p.tdata  = vif.tdata;
                p.tid    = vif.tid;
                p.tlast  = vif.tlast;
                in_mbx.put(p);
            end
        endtask

    endclass
    
    // Slave

    class slave_monitor_base;

        virtual axis_intf vif;

        mailbox#(packet) out_mbx;

        virtual task run();
            forever begin
                wait(vif.aresetn);
                fork
                    forever begin
                        monitor_slave();
                    end
                join_none
                wait(~vif.aresetn);
                disable fork;
            end
        endtask

        virtual task monitor_slave();
            packet p;
            @(posedge vif.clk);
            if( vif.tvalid & vif.tready ) begin
                p = new();
                p.tdata  = vif.tdata;
                p.tid    = vif.tid;
                p.tlast  = vif.tlast;
                out_mbx.put(p);
            end
        endtask

    endclass