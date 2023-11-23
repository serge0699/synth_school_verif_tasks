// TODO: fill generator class

class generator;

    // TODO: declare mailbox parameterized with 'transaction' type and 'mbx' name


    // TODO: declare 'conf' field with 'cfg' type


    // TODO: declare 'data' field with 'transaction' type


    // TODO: create virtual 'run()' task
    // Task must call 'gen()' 'conf.amount' times
    // Use 'repeat'


    // This task will generate random input signal
    // and pass transaction to the mailbox

    virtual task gen();
        data = new();
        data.signal_in = $random();
        mbx.put(data);
    endtask

endclass