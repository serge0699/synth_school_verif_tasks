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

    class array_alu_apb_vr_va_gen extends apb_master_gen_base;

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
                    if( paddr == array_alu_pkg::START ) {
                        pwrite == 1;
                    }
                    if( paddr == array_alu_pkg::DONE ) {
                        pwrite == 0;
                    }
                } 
            ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        endtask

    endclass

    class array_alu_apb_vr_va_vd_gen extends apb_master_gen_base;

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
                    if( paddr == array_alu_pkg::START ) {
                        pwrite == 1;
                    }
                    if( paddr == array_alu_pkg::DONE ) {
                        pwrite == 0;
                    }
                    if( paddr == array_alu_pkg::OP ) {
                        pwdata inside {
                            array_alu_pkg::ADD,
                            array_alu_pkg::SUB,
                            array_alu_pkg::MUL
                        };
                    }
                } 
            ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        endtask

    endclass

    class array_alu_apb_work_mode_gen extends apb_master_gen_base;

        virtual task run();
            apb_packet_base p;
            // Generate operation
            p = create_packet();
            if(
                !p.randomize() with {
                    paddr == OP;
                    pwdata inside {ADD, SUB, MUL};
                    pwrite == 1;
                }
            ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
            // Generate START signal
            p = create_packet();
            if(
                !p.randomize() with {
                    paddr == START;
                    pwrite == 1;
                }
            ) begin
                $error("Can't randomize packet!");
                $finish();
            end
            gen2drv.put(p);
        endtask

    endclass

    class array_alu_apb_work_mode_resp_gen extends apb_master_gen_base;

        virtual task run();
            apb_packet_base p;
            // Read DONE register while not 1
            do begin
                p = create_packet();
                if(
                    !p.randomize() with {
                        paddr == DONE;
                        pwrite == 0;
                    }
                ) begin
                    $error("Can't randomize packet!");
                    $finish();
                end
                gen2drv.put(p);
                // Get response
                gen2drv.get(p);
            end
            while( p.prdata !== 1 );
        endtask

    endclass