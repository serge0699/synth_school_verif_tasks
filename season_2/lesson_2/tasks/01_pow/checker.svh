    event done_100;
    event done_2;
    event done_3;

    initial begin

        // Numbers inside [0:25]
        fork
            forever begin
                @(posedge clk);
                if( !(A inside {[0:25]}) ) begin
                    $error("A not inside [0:25]!");
                    $stop();
                end
            end
            wait(done_100.triggered());
        join_any
        disable fork;

        @(posedge clk);

        // Even numbers
        fork
            forever begin
                @(posedge clk);
                if( A[0] != 0 ) begin
                    $error("A is not even!");
                    $stop();
                end
            end
            wait(done_2.triggered());
        join_any
        disable fork;

        @(posedge clk);

        // Numbers divisible by 3
        fork
            forever begin
                @(posedge clk);
                if( A % 3 != 0 ) begin
                    $error("A is not dibisible by 3!");
                    $stop();
                end
            end
            wait(done_3.triggered());
        join_any
        disable fork;

        $display("Test finished!");
        $stop();

    end