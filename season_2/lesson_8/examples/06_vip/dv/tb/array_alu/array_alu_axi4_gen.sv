    class array_alu_axi4_vr_gen extends axi4_master_gen_base;

        virtual task gen_master();
            axi4_packet_base p;
            p = create_packet();
            if(
                !p.randomize() with {
                    awaddr inside {A0, A1, A2, A3, B0, B1, B2, B3, C0, C1, C2, C3};
                    araddr inside {A0, A1, A2, A3, B0, B1, B2, B3, C0, C1, C2, C3};
                }
            ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        endtask

    endclass