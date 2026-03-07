package test_mult_pkg;

    import test_pkg::*;

    class checker_mult_base extends checker_base;

        virtual task check(packet in, packet out);
            if( in.tid !== out.tid ) begin
                $error("%0t Invalid TID: Real: %h, Expected: %h",
                    $time(), out.tid, in.tid);
            end
            if( out.tdata !== in.tdata * in.tdata ) begin
                $error("%0t Invalid TDATA: Real: %0d, Expected: %0d * %0d = %0d",
                    $time(), out.tdata, in.tdata, in.tdata, in.tdata * in.tdata);
            end
            if( in.tlast !== out.tlast ) begin
                $error("%0t Invalid TLAST: Real: %1b, Expected: %1b",
                    $time(), out.tlast, in.tlast);
            end
        endtask

    endclass

    class test_mult_base extends test_base;

        function new (
            virtual axis_intf vif_master,
            virtual axis_intf vif_slave
        );
            checker_mult_base check_mult;
            super.new(vif_master, vif_slave);
            // Переопределение чекера
            check_mult = new();
            env.check = check_mult;
            env.check.cfg = cfg;
            env.check.in_mbx = in_mbx;
            env.check.out_mbx = out_mbx;
        endfunction

    endclass

endpackage