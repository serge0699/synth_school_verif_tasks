    class axi4_env_base;

        axi4_master_agent_base master;
        axi4_checker_base      check;

        function new();
            master = new();
            check  = new();
        endfunction

        virtual task run();
            fork
                master.run();
                check .run();
            join
        endtask

    endclass