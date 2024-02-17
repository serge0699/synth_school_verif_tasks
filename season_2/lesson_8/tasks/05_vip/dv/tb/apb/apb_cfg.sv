class apb_cfg_base;

    rand int unsigned master_pkt_amount = 150;
    rand int unsigned master_delay_min  = 0;
    rand int unsigned master_delay_max  = 10;

    function void post_randomize();
        string str;
        str = {str, $sformatf("master_pkt_amount  : %0d\n", master_pkt_amount  )};
        str = {str, $sformatf("master_delay_min   : %0d\n", master_delay_min   )};
        str = {str, $sformatf("master_delay_max   : %0d\n", master_delay_max   )};
        $display(str);
    endfunction

    constraint master_pkt_amount_c {
        master_pkt_amount inside {[100:200]};
    };

    constraint master_delay_min_c {
        master_delay_min inside {[0:4]};
    };

    constraint master_delay_max_c {
        master_delay_max inside {[5:10]};
    };

endclass