interface axi4_intf(
    input logic clk,
    input logic aresetn
);

    logic            awvalid;
    logic            awready;
    logic     [31:0] awaddr;
    logic            wvalid;
    logic            wready;
    logic     [31:0] wdata;
    logic            bvalid;
    logic     [ 2:0] bresp;
    logic            bready;
    logic            arvalid;
    logic            arready;
    logic     [ 2:0] arid;
    logic     [31:0] araddr;
    logic            rvalid;
    logic            rready;
    logic     [ 2:0] rid;
    logic     [31:0] rdata;
    logic     [ 2:0] rresp;

endinterface