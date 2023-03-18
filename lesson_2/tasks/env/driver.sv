// TODO: fill monitor class

class driver;

    // TODO: declare mailbox parameterized with 'transaction' type and 'mbx' name


    // TODO: declare 'conf' field with 'cfg' type


    // TODO: declare 'data' field with 'transaction' type


    // TODO: declare virtual interface 'vif' with type 'inv_if'


    // TODO: create virtual 'run()' task
    // In this task input signal must be dropped like: 'vif.signal_in <= 0;'
    // After that every 'conf.latency' posedges of 'vif.clk' task must call
    // 'drive()'. Use 'forever' loop


    // This task will get transaction from the mailbox
    // and drive transaction on the interface

    virtual task automatic drive();
        mbx.get(data);
        vif.signal_in <= data.signal_in;
    endtask

endclass