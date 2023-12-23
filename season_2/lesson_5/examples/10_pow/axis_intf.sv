interface axis_intf(input logic clk, input logic aresetn);

    logic        tvalid;
    logic        tready;
    logic [31:0] tdata;
    logic        tid;
    logic        tlast;

endinterface