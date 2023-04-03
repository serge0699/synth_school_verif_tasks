`include "interface.sv"

module testbench();

    // Package can be used here

    `include "cfg.sv"
    `include "transaction.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "generator.sv"
    `include "scoreboard.sv"
    `include "env.sv"
    `include "test.sv"

    // Clock

    bit clk;

    // Interface

    inv_if intf(clk);

    // Virtual interface

    virtual inv_if vintf = intf;

    // Test class

    test t;

    // Design Under Test

    inv DUT (
        .clk       (clk            ),
        .signal_in (intf.signal_in ),
        .signal_out(intf.signal_out)
    );

    // Clock generation

    initial begin
        clk <= 0;
        forever begin
            #10; clk <= ~clk;
        end
    end

    // Test run

    initial begin
        t = new(vintf);
        t.run();
    end

endmodule
