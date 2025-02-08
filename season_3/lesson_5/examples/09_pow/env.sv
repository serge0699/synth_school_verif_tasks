    class env_base;

        master_agent_base master;
        slave_agent_base  slave;
        checker_base      check;

        function new();
            master  = new();
            slave   = new();
            check   = new();
        endfunction

        virtual task run();
            fork
                master.run();
                slave .run();
                check .run();
            join
        endtask

    endclass
