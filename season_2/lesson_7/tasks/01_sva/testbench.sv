module testbench;

    parameter CLK_PERIOD = 10;

    logic clk;
    logic ready;
    logic request;

    // clk
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    // ready
    initial begin
        ready <= 0;
        repeat(10) begin
            repeat($urandom_range(50, 100)) @(posedge clk);
            ready <= 1;
            @(posedge clk);
            ready <= 0;
        end
    end

    // finish
    initial begin
        repeat(10) @(posedge request);
        @(posedge clk);
        $finish();
    end

    // DUT
    requester DUT (
        .clk    ( clk     ),
        .ready  ( ready   ),
        .request( request )
    );

    // TODO: 
    // Напишите SVA, определяющий, что если 'ready'
    // равен 1, то в течение от 1 до 10 тактов после
    // этого 'request' будет равен 1.
    // TODO: 
    // Определите, выполняется ли  описанное 
    // в SVA условие в ходе симуляции. 
    property pReadyReq;
        @(posedge clk) /* Пишите здесь */
    endproperty

    apHandshake: assert property(pReadyReq) begin
        $display("%0t Good %m!", $time());
    end else begin
        $display("%0t Bad %m!", $time());
        $stop();
    end

endmodule
