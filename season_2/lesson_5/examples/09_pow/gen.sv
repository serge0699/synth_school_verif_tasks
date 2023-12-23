    // Master

    class master_gen_base;

        test_cfg_base cfg;

        mailbox#(packet) gen2drv;

        virtual task run();
            repeat(cfg.master_pkt_amount) begin
                gen_master();
            end
        endtask

        virtual task gen_master();
            packet p;
            int size;
            void'(std::randomize(size) with {size inside {
                [cfg.master_size_min:cfg.master_size_max]};});
            for(int i = 0; i < size; i = i + 1) begin
                p = create_packet();
                if( !p.randomize() with {
                    p.delay inside {[cfg.master_delay_min:cfg.master_delay_max]};
                    p.tlast == (i == size - 1);
                } ) begin
                    $error("Can't randomize packet!");
                    $finish();
                end
                gen2drv.put(p);
            end
        endtask

        virtual function packet create_packet();
            packet p;
            p = new();
            return p;
        endfunction

    endclass