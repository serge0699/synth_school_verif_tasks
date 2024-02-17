    // Master
    
    class apb_monitor_base;

        virtual apb_intf vif;

        mailbox#(apb_packet_base) mbx;

        // Main run

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
            apb_packet_base p;
            // Wait for PSEL
            do begin
                @(posedge vif.clk);
            end
            while( !vif.psel );
            // Check for PSEL-PENABLE 'handshake'
            @(posedge vif.clk);
            // If at this point no PSEL and
            // PENABLE - skip tranaction
            while( vif.psel && vif.penable ) begin
                // If got PREADY - save transaction
                if( vif.pready ) begin
                    p = new();
                    p.paddr   = vif.paddr;
                    p.pwrite  = vif.pwrite;
                    p.pwdata  = vif.pwdata;
                    p.prdata  = vif.prdata;
                    p.pslverr = vif.pslverr;
                    mbx.put(p);
                    break;
                end
                @(posedge vif.clk);
            end
        endtask

    endclass
