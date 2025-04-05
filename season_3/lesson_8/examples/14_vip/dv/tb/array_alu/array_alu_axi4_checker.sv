    class array_alu_axi4_checker_base extends axi4_checker_base;

        // Internal APB checker

        apb_checker_base apb_checker;

        // Mailboxes

        mailbox#(apb_packet_base ) apb_mbx;


        // Registers

        op_t op; int unsigned a_reg [4], b_reg [4], c_reg [4];

        // New

        function new();
            apb_checker      = new();
            apb_checker.mbx  = new();
            apb_mbx          = new();
        endfunction

        // Main run

        virtual task do_check();
            apb_packet_base  apb_p;
            fork
                // Общая проверка AXI4
                super.do_check();
                forever begin
                    apb_mbx.get(apb_p);
                    // Локальная проверка
                    analyze_apb(apb_p);
                    // Общая проверка
                    apb_checker.mbx.put(apb_p);
                end
            join
        endtask

        virtual function void analyze_apb(apb_packet_base p);
            if( p.paddr == OP ) begin
                if( p.pwrite ) begin
                    op = op_t'(p.pwdata);
                end
                else begin
                    if( p.prdata !== op ) begin
                        $error("Invalid OP value! Real: %h, Expected: %h",
                            p.prdata, op);
                    end
                end
            end
            if( p.paddr == START ) begin
                case( op )
                    ADD    : foreach(c_reg[i]) c_reg[i] = a_reg[i] + b_reg[i];
                    SUB    : foreach(c_reg[i]) c_reg[i] = a_reg[i] - b_reg[i];
                    MUL    : foreach(c_reg[i]) c_reg[i] = a_reg[i] * b_reg[i];
                    // If wrong operation - do nothing
                    default: ;
                endcase
            end
        endfunction

        virtual function void analyze_b(axi4_packet_base p);
            case(p.awaddr)
                A0     : a_reg [0] = p.wdata;
                A1     : a_reg [1] = p.wdata;
                A2     : a_reg [2] = p.wdata;
                A3     : a_reg [3] = p.wdata;
                B0     : b_reg [0] = p.wdata;
                B1     : b_reg [1] = p.wdata;
                B2     : b_reg [2] = p.wdata;
                B3     : b_reg [3] = p.wdata;
                C0     : c_reg [0] = p.wdata;
                C1     : c_reg [1] = p.wdata;
                C2     : c_reg [2] = p.wdata;
                C3     : c_reg [3] = p.wdata;
                default: ;
            endcase
        endfunction

        virtual function void analyze_r(axi4_packet_base p);
            $display("%h %0d %0d ", p.araddr, p.rdata, c_reg [0]);
            case(p.araddr)
                A0     : if( p.rdata !== a_reg [0] ) begin
                            $error("Invalid A0 value! Real: %h, Expected: %h",
                                p.rdata, a_reg [0]);
                         end
                A1     : if( p.rdata !== a_reg [1] ) begin
                            $error("Invalid A1 value! Real: %h, Expected: %h",
                                p.rdata, a_reg [1]);
                         end
                A2     : if( p.rdata !== a_reg [2] ) begin
                            $error("Invalid A2 value! Real: %h, Expected: %h",
                                p.rdata, a_reg [2]);
                         end
                A3     : if( p.rdata !== a_reg [3] ) begin
                            $error("Invalid A3 value! Real: %h, Expected: %h",
                                p.rdata, a_reg [3]);
                         end
                B0     : if( p.rdata !== b_reg [0] ) begin
                            $error("Invalid B0 value! Real: %h, Expected: %h",
                                p.rdata, b_reg [0]);
                         end
                B1     : if( p.rdata !== b_reg [1] ) begin
                            $error("Invalid B1 value! Real: %h, Expected: %h",
                                p.rdata, b_reg [1]);
                         end
                B2     : if( p.rdata !== b_reg [2] ) begin
                            $error("Invalid B2 value! Real: %h, Expected: %h",
                                p.rdata, b_reg [2]);
                         end
                B3     : if( p.rdata !== b_reg [3] ) begin
                            $error("Invalid B3 value! Real: %h, Expected: %h",
                                p.rdata, b_reg [3]);
                         end
                C0     : if( p.rdata !== c_reg [0] ) begin
                            $error("Invalid C0 value! Real: %h, Expected: %h",
                                p.rdata, c_reg [0]);
                         end
                C1     : if( p.rdata !== c_reg [1] ) begin
                            $error("Invalid C1 value! Real: %h, Expected: %h",
                                p.rdata, c_reg [1]);
                         end
                C2     : if( p.rdata !== c_reg [2] ) begin
                            $error("Invalid C2 value! Real: %h, Expected: %h",
                                p.rdata, c_reg [2]);
                         end
                C3     : if( p.rdata !== c_reg [3] ) begin
                            $error("Invalid C3 value! Real: %h, Expected: %h",
                                p.rdata, c_reg [3]);
                         end
                default: ;
            endcase
        endfunction


    endclass