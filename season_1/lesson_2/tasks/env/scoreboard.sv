class scoreboard;

    // TODO: declare mailbox parameterized with 'transaction' type and 'mbx' name


    // TODO: declare 'conf' field with 'cfg' type


    // TODO: declare two fields with 'transaction' type and names
    //       'data_in' and 'data_out'


    // TODO: Declare fields with type 'bit' and name 'done'
    // This field will indicate the end of the comparison

    
    // This task will compare transactions 'conf.amount'
    // times and set done bit after that

    virtual task run();
        repeat(conf.amount) begin
            compare();
        end
        done = 1;
    endtask

    // Get and compare, if neccessary
    // Note how we handle one cycle design delay via
    // setting 'data_in' after first compare attempt

    virtual task compare();
        mbx.get(data_out);
        if(data_in != null) compare_trans();
        data_in = data_out;
    endtask

    // Compare transactions and print result

    virtual function void compare_trans();
        if( data_out != null ) begin
            if( calc(data_in.signal_in) != data_out.signal_out ) begin
                $display("ERROR: Real: %1b != Expected: %1b, Time: %1t",
                    data_out.signal_out, calc(data_in.signal_in), $time());
            end
            else begin
                $display("GOOD: Real: %1b == Expected: %1b, Time: %1t",
                    data_out.signal_out, calc(data_in.signal_in), $time());
            end
        end
    endfunction

    // TODO: create virtual function with name 'calc',
    //       which returns inversion of bit

    // Template: virtual function bit calc(bit a);


endclass