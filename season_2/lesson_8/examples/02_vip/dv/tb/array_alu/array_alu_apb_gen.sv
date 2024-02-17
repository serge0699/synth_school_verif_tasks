    class array_alu_apb_vr_gen extends apb_master_gen_base;

        virtual task gen_master();
            apb_packet_base p;
            p = create_packet();
            if(
                !p.randomize() with {
                    paddr inside {
                        array_alu_pkg::OP,
                        array_alu_pkg::START,
                        array_alu_pkg::DONE
                    };
                } 
            ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        endtask

    endclass
