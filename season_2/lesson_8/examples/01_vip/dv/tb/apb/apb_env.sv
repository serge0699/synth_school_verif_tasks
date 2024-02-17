    class apb_env_base;

        apb_master_agent_base master;
        apb_checker_base      check;

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