module testbench;

    `include "assert_utils.svh"

    parameter CLK_PERIOD = 10;

    logic clk;
    logic a;
    logic b;
    logic c;

    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    // a, b
    initial begin
        a <= 0;
        b <= 0;
        c <= 0;
        @(posedge clk);
        a <= 1;
        @(posedge clk);
        a <= 0;
        b <= 1;
        @(posedge clk);
        c <= 1;
    end

    // assert
    property pABC;
        @(posedge clk) a ##[1:4] b ##1 c;
    endproperty

    property pABCfm;
        @(posedge clk) first_match(a ##[1:4] b ##1 c);
    endproperty

    `ASSERT_WITH(pABC);
    `ASSERT_WITH(pABCfm);

endmodule
