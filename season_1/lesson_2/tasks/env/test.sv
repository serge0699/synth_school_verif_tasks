class test;

    // TODO: declare 'conf' field with 'cfg' type


    // TODO: declare 'environment' variable with 'env' type


    // Contructor will create configuration
    // and create environment

    function new(virtual inv_if vif);
        create_conf();
        environment = new(conf, vif);
    endfunction

    // Create configuration

    virtual function void create_conf();
        conf = new();
        conf.latency = 1;
        conf.amount = 100;
    endfunction

    // Run environment and wait for test done

    virtual task run();
        environment.run();
        wait(environment.scb.done);
        $finish();
    endtask

endclass