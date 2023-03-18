class env;

    // TODO: generator, driver, monitor, scoreboard
    //       with names 'gen', 'drv', 'mon', 'scb' respectively


    // TODO: declare 2 mailboxes parameterized with 'transaction'
    //       type and 'gen2drv_mbx', 'mon2scb_mbx' names
    // This mailboxes will be created and used for generator and
    // driver connection, as well as monitor and scoreboard (see
    // connect_comp() function)


    // This function will create, configure and connect
    // all components. This is constructor, by the way

    function new(cfg conf, virtual inv_if vif);
        create_comp();
        conf_comp(conf, vif);
        connect_comp();
    endfunction

    // TODO: create 'create_comp()' and create
    // generator, driver, monitor, scoreboard in it


    // This function will pass config to the components
    // Also this function will pass virtual interfaces
    // to the components

    virtual function void conf_comp(cfg conf, virtual inv_if vif);
        gen.conf = conf;
        drv.conf = conf;
        scb.conf = conf;
        drv.vif  = vif;
        mon.vif  = vif;
    endfunction

    // This function will connect components via mailboxes

    virtual function void connect_comp();
        gen2drv_mbx = new();
        mon2scb_mbx = new();
        gen.mbx = gen2drv_mbx;
        drv.mbx = gen2drv_mbx;
        mon.mbx = mon2scb_mbx;
        scb.mbx = mon2scb_mbx;
    endfunction

    // This task will run all components in parallel

    virtual task run();
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none // This will run all run()'s in parallel
    endtask

endclass