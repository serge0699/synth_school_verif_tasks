module testbench;

    parameter CLK_PERIOD = 10;

    logic clk;
    logic ready;
    logic request;

    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    // ready
    initial begin
        ready <= 0;
        forever begin
            repeat($urandom_range(6, 10)) @(posedge clk);
            ready <= 1;
            @(posedge clk);
            ready <= 0;
        end
    end

    // request
    initial begin
        request <= 0;
        @(posedge clk);
        forever begin
            while(!ready) @(posedge clk);
            repeat($urandom_range(0, 1)) @(posedge clk);
            request <= 1;
            @(posedge clk);
            request <= 0;
        end
    end

    // assert
    property pExampleOfDelay;
        @(posedge clk) (readyReq);
    endproperty

    sequence readyReq;
        (ready ##1 request);
    endsequence

    apHandshake: assert property(pExampleOfDelay) begin
        $display("Good!");
        $stop();
    end else begin
        $display("Bad!");
        $stop();
    end

endmodule
