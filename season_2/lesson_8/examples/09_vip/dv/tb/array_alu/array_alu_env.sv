    class array_alu_env_base;

        // APB env

        apb_env_base apb_env;

        // AXI4 env

        axi4_env_base axi4_env;

        function new();
            apb_env  = new();
            axi4_env = new();
        endfunction

        virtual task run();
            fork
                apb_env.run();
                axi4_env.run();
            join
        endtask

    endclass