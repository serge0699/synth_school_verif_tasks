module testbench;

    parameter CLK_PERIOD = 10;

    logic clk;
    logic ready;
    logic request;
    logic ack;
    logic done;

    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    // timeout
    initial begin
        repeat(10000) @(posedge clk);
        $display("Timeout!");
        $stop();
    end

    // ready, req
    initial begin
        ready    <= 0;
        request  <= 0;
        forever begin
            @(posedge clk);
            ready   <= 1;
            @(posedge clk);
            request <= 1;
            @(posedge clk);
            request <= 0;
            repeat(2) @(posedge clk);
        end
    end

    // ack, done
    initial begin
        ack  <= 0;
        done <= 0;
        @(posedge clk);
        forever begin
            while (!request)
            @(posedge clk);
            ack <= 1;
            @(posedge clk);
            done <= 1;
            @(posedge clk);
            done <= 0;
        end
    end

    // assert
    property pComplex;
        @(posedge clk) (ready ##1 request) |=> (ack ## 1 done);
    endproperty

    apComplex: assert property(pComplex) begin
        $display("Good!");
        $stop();
    end else begin
        $display("Bad!");
        $stop();
    end

endmodule
