    // AXI4 master

    class axi4_master_gen_base;

        axi4_cfg_base cfg;

        mailbox#(axi4_packet_base) gen2drv;

        virtual task run();
            repeat(cfg.master_pkt_amount) begin
                gen_master();
            end
        endtask

        virtual task gen_master();
            axi4_packet_base p;
            p = create_packet();
            if( !p.randomize() ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        endtask

        virtual function axi4_packet_base create_packet();
            axi4_packet_base p;
            p = new();
            return p;
        endfunction

    endclass