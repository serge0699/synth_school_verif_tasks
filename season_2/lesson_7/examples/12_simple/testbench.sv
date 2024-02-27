module testbench;

    parameter CLK_PERIOD = 10;

    logic clk;
    logic req;
    logic ack;

    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    // req
    initial begin
        req <= 0;
        forever begin
            @(posedge clk);
            req <= 1;
            @(posedge clk);
            req <= 0;
            while(!ack) @(posedge clk);
        end
    end

    // ack
    initial begin
        ack <= 0;
        @(posedge clk);
        forever begin
            while (!req)
            @(posedge clk);
            repeat(1) @(posedge clk);
            ack <= 1;
            @(posedge clk);
            ack <= 0;
        end
    end

    // assert
    property pHandshake;
        @(posedge clk) req |=> ## [0:4] ack; 
    endproperty

    apHandshake: assert property(pHandshake) begin
        $display("Good!");
        $stop();
    end else begin
        $display("Bad!");
        $stop();
    end

endmodule
