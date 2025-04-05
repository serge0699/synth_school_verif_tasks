    // AXI4 master
    
    class axi4_master_agent_base;

        axi4_master_gen_base    master_gen;
        axi4_monitor_base       master_monitor;
        axi4_master_driver_base master_driver;

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
