    class checker_base;

        test_cfg_base cfg;

        bit done;
        int cnt;
        bit in_reset;

        mailbox#(packet) in_mbx;
        mailbox#(packet) out_mbx;

        virtual task run();
            packet tmp_p;
            forever begin
                wait(~in_reset);
                fork
                    do_check();
                    wait(in_reset);
                join_any
                disable fork;
                if( done ) break;
                while(in_mbx.try_get(tmp_p)) cnt = cnt + 1;
            end
        endtask

        virtual task check(packet in, packet out);
            assert( in.tid === out.tid ) else begin
                $error("%0t Invalid TID: Real: %h, Expected: %h",
                    $time(), out.tid, in.tid);
            end
            assert( out.tdata === in.tdata ** 5 ) else begin
                $error("%0t Invalid TDATA: Real: %0d, Expected: %0d ^ 5 = %0d",
                    $time(), out.tdata, in.tdata, in.tdata ** 5);
            end
            assert( in.tlast === out.tlast ) else begin
                $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                    $time(), out.tlast, in.tlast);
            end
        endtask

        virtual task do_check();
            packet in_p, out_p;
            forever begin
                in_mbx.get(in_p);
                out_mbx.get(out_p);
                check(in_p, out_p);
                cnt = cnt + out_p.tlast;
                if( cnt == cfg.master_pkt_amount ) begin
                    done = 1;
                    break;
                end
            end
        endtask

    endclass