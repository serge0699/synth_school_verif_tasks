    // APB master
    
    class apb_master_agent_base;

        apb_master_gen_base     master_gen;
        apb_monitor_base        master_monitor;
        apb_master_driver_base  master_driver;

        function new();
            master_gen     = new();
            master_monitor = new();
            master_driver  = new();
        endfunction

        virtual task run();
            fork
                master_driver .run();
                master_monitor.run();
            join
        endtask

    endclass
