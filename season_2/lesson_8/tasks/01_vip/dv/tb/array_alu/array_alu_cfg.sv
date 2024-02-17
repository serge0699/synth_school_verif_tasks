    class array_alu_cfg_base;

        // Random AXI4 config
        rand axi4_cfg_base axi4_cfg;

        // Random APB config
        rand apb_cfg_base apb_cfg;

        // Test timeout
        int unsigned test_timeout_cycles = 10000;

        // Create nested configs
        function new();
            axi4_cfg = new();
            apb_cfg = new();
        endfunction

        function void post_randomize();
            string str;
            str = {str, $sformatf("test_timeout_cycles: %0d\n", test_timeout_cycles)};
            $display(str);
        endfunction

    endclass