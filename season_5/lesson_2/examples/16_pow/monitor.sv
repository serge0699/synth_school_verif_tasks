    // Master
    
    class master_monitor_base;

        mailbox#(packet) in_mbx;

        virtual task run();
            forever begin
                wait(aresetn);
                fork
                    forever begin
                        monitor_master();
                    end
                join_none
                wait(~aresetn);
                disable fork;
            end
        endtask

        virtual task monitor_master();
            packet p;
            @(posedge clk);
            if( s_tvalid & s_tready ) begin
                p = new();
                p.tdata  = s_tdata;
                p.tid    = s_tid;
                p.tlast  = s_tlast;
                in_mbx.put(p);
            end
        endtask

    endclass
    
    // Slave

    class slave_monitor_base;

        mailbox#(packet) out_mbx;
        
        virtual task run();
            forever begin
                wait(aresetn);
                fork
                    forever begin
                        monitor_slave();
                    end
                join_none
                wait(~aresetn);
                disable fork;
            end
        endtask

        virtual task monitor_slave();
            packet p;
            @(posedge clk);
            if( m_tvalid & m_tready ) begin
                p = new();
                p.tdata  = m_tdata;
                p.tid    = m_tid;
                p.tlast  = m_tlast;
                out_mbx.put(p);
            end
        endtask

    endclass