    class checker_base;

        test_cfg_base cfg;

        bit done;

        mailbox#(packet) in_mbx;
        mailbox#(packet) out_mbx;
        
        virtual task run();
            do_check();
        endtask

        virtual task check(packet in, packet out);
            if( in.tid !== out.tid ) begin
                $error("%0t Invalid TID: Real: %h, Expected: %h",
                    $time(), out.tid, in.tid);
            end
            if( out.tdata !== in.tdata ** 5 ) begin
                $error("%0t Invalid TDATA: Real: %0d, Expected: %0d ^ 5 = %0d",
                    $time(), out.tdata, in.tdata, in.tdata ** 5);
            end
            if( in.tlast !== out.tlast ) begin
                $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                    $time(), out.tlast, in.tlast);
            end
        endtask

        virtual task do_check();
            int cnt;
            packet in_p, out_p;
            forever begin
                wait(aresetn);
                fork
                    forever begin
                        in_mbx.get(in_p);
                        out_mbx.get(out_p);
                        check(in_p, out_p);
                        cnt = cnt + out_p.tlast;
                        if( cnt == cfg.master_pkt_amount ) begin
                            break;
                        end
                    end
                    begin
                        wait(~aresetn);
                    end
                join_any
                disable fork;
                // Если достигли нужного количества пакетов,
                // то выходим из бесконечного цикла и выставляем
                // флаг завершения
                if( cnt == cfg.master_pkt_amount ) begin
                    done = 1;
                    break;
                end
                // Иначе пришел сигнал сброса. Очищаем mailbox
                // от входящих транзакций, т.к все они будут
                // "выкинуты" из конвейера при приходе сигнала сброса
                while(in_mbx.try_get(in_p)) cnt = cnt + 1;
            end
        endtask

    endclass