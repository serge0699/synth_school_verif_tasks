interface axis_intf(input logic clk, input logic aresetn);

    logic        tvalid;
    logic        tready;
    logic [31:0] tdata;
    logic        tid;
    logic        tlast;

    property pTvalidStable;
        @(posedge clk) tvalid & ~tready |-> ##1 tvalid; 
    endproperty

    apTvalidStable: assert property(pTvalidStable) begin
        $display("Good at time %0d", $time());
        $stop();
    end
    else begin
        $display("Bad at time %0d", $time());
        $stop();
    end

endinterface

