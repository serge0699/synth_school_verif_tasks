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

    class array_alu_axi4_work_mode_gen extends axi4_master_gen_base;

        // Generator addresses for every array entry
        array_alu_regs_t addresses [] = '{A0, A1, A2, A3, B0, B1, B2, B3};

        virtual task run();
            axi4_packet_base p;
            // We must generate every array entry
            // address and data phases
            foreach(addresses[i]) begin
                // Address phase
                p = create_packet();
                if(
                    !p.randomize() with {
                        awaddr == addresses[i];
                        channel == AW;
                    }
                ) begin
                    $error("Can't randomize packet!");
                    $finish();
                end
                gen2drv.put(p);
                // Data phase
                p = create_packet();
                if(
                    !p.randomize() with {
                        channel == W;
                    }
                ) begin
                    $error("Can't randomize packet!");
                    $finish();
                end
                gen2drv.put(p);
            end
        endtask

    endclass

    class array_alu_axi4_work_mode_resp_gen extends axi4_master_gen_base;

        // Generator addresses for every array entry
        array_alu_regs_t addresses [] = '{C0, C1, C2, C3};

        virtual task run();
            axi4_packet_base p;
            // We must generate every array entry
            // address and data phases
            foreach(addresses[i]) begin
                // Address phase
                p = create_packet();
                if(
                    !p.randomize() with {
                        araddr == addresses[i];
                        channel == AR;
                    }
                ) begin
                    $error("Can't randomize packet!");
                    $finish();
                end
                gen2drv.put(p);
            end
        endtask

    endclass