    // Master
    
    class axi4_monitor_base;

        virtual axi4_intf vif;

        mailbox#(axi4_packet_base) mbx;

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

        // Monitor all channels independently

        virtual task monitor_master();
            axi4_packet_base p_aw, p_w, p_ar, p_b, p_r;
            fork
                forever begin
                    // Monitor adress write
                    p_aw = new();
                    do_aw(p_aw); mbx.put(p_aw);
                end
                forever begin
                    // Monitor data write
                    p_w = new();
                    do_w(p_w); mbx.put(p_w);
                end
                forever begin
                    // Monitor address read
                    p_ar = new();
                    do_ar(p_ar); mbx.put(p_ar);
                end
                forever begin
                    // Monitor write response
                    p_b = new();
                    do_b(p_b); mbx.put(p_b);
                end
                forever begin
                    // Monitor read response
                    p_r = new();
                    do_r(p_r); mbx.put(p_r);
                end
            join
        endtask

        // Set write address signals

        virtual task do_aw(axi4_packet_base p);
            // Wait for ready
            do begin
                @(posedge vif.clk);
            end
            while( !(vif.awvalid && vif.awready) );
            // Save data
            p.channel = AW;
            p.awaddr  = vif.awaddr;
        endtask

        // Set write data signals

        virtual task do_w(axi4_packet_base p);
            // TODO:
            // Реализуйте сохранение пакетов с
            // канала данных записи. В качестве
            // примера используйте задачу do_aw()
            // Не забудьте сохранять информацию
            // о канале через p.channel = <канал>
            @(posedge vif.clk); // NOTE: Уберите эту заглушку
        endtask

        // Set read address signals

        virtual task do_ar(axi4_packet_base p);
            // TODO:
            // Реализуйте сохранение пакетов с
            // канала адреса чтения. В качестве
            // примера используйте задачу do_aw()
            // Не забудьте сохранять информацию
            // о канале через p.channel = <канал>
            @(posedge vif.clk); // NOTE: Уберите эту заглушку
        endtask

        // Set write response signals

        virtual task do_b(axi4_packet_base p);
            // TODO:
            // Реализуйте сохранение пакетов с
            // канала ответа записи. В качестве
            // примера используйте задачу do_aw()
            // Не забудьте сохранять информацию
            // о канале через p.channel = <канал>
            @(posedge vif.clk); // NOTE: Уберите эту заглушку
        endtask

        // Set read data signals

        virtual task do_r(axi4_packet_base p);
            // TODO:
            // Реализуйте сохранение пакетов с
            // канала ответа чтения. В качестве
            // примера используйте задачу do_aw()
            // Не забудьте сохранять информацию
            // о канале через p.channel = <канал>
            @(posedge vif.clk); // NOTE: Уберите эту заглушку
        endtask

    endclass
