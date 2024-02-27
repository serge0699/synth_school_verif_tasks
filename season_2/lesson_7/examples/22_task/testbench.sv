module testbench;

    `include "assert_utils.svh"

    parameter CLK_PERIOD = 10;

    logic clk;
    logic       req;
    logic [7:0] addr;
    logic       ack;
    logic [7:0] data;

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

    // req, addr
    initial begin
        req  <= 0;
        addr <= 'x;
        forever begin
            @(posedge clk);
            req  <=  1;
            addr <= '0;
            @(posedge clk);
            req  <=  0;
            addr <= 'x;
            repeat(5) @(posedge clk);
        end
    end

    // ack, data
    initial begin
        ack  <=  0;
        data <= 'x;
        forever begin
            @(posedge req);
            repeat(4) @(posedge clk);
            ack  <= 1;
            data <= 8'hFF;
            @(posedge clk);
            ack  <=  0;
            data <= 'x;
        end
    end

    // assertions
    property pTask1;
        @(posedge clk) (req && (addr === 'h0)) |=> ## [0:4] ack;
    endproperty

    property pTask2;
        @(posedge clk) (req && (addr === 'h0)) |=> ##3 ack;
    endproperty

    property pTask3;
        @(posedge clk) (req && (addr === 'h0)) |=> ack;
    endproperty

    `ASSERT_WITH(pTask1)
    `ASSERT_WITH(pTask2)
    `ASSERT_WITH(pTask3)

endmodule
