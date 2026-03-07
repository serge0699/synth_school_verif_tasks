    class test_cfg_base;

        rand int master_pkt_amount    = 100;
        rand int master_size_min      = 1;
        rand int master_size_max      = 10;
        rand int master_delay_min     = 0;
        rand int master_delay_max     = 10;
        rand int slave_delay_min      = 0;
        rand int slave_delay_max      = 10;
             int test_timeout_cycles  = 10000000;

        constraint gen_pkt_amount_c {
            master_pkt_amount inside {[100:500]};
        }

        constraint gen_size_c {
            master_size_min inside {[1:50]};
            master_size_max inside {[1:500]};
            master_size_max >= master_size_min;
        }

        constraint master_delay_c {
            master_delay_min inside {[0:20]};
            master_delay_max inside {[0:20]};
            master_delay_max >= master_delay_min;
        }

        constraint slave_delay_c {
            slave_delay_min inside {[0:20]};
            slave_delay_max inside {[0:20]};
            slave_delay_max >= slave_delay_min;
        }

        function void post_randomize();
            string str;
            str = {str, $sformatf("master_pkt_amount  : %0d\n", master_pkt_amount  )};
            str = {str, $sformatf("master_size_min    : %0d\n", master_size_min    )};
            str = {str, $sformatf("master_size_max    : %0d\n", master_size_max    )};
            str = {str, $sformatf("master_delay_min   : %0d\n", master_delay_min   )};
            str = {str, $sformatf("master_delay_max   : %0d\n", master_delay_max   )};
            str = {str, $sformatf("slave_delay_min    : %0d\n", slave_delay_min    )};
            str = {str, $sformatf("slave_delay_max    : %0d\n", slave_delay_max    )};
            str = {str, $sformatf("test_timeout_cycles: %0d\n", test_timeout_cycles)};
            $display(str);
        endfunction

    endclass