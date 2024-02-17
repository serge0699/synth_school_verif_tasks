interface apb_intf(
    input logic clk,
    input logic aresetn
);

    logic [31:0] paddr;
    logic        psel;
    logic        penable;
    logic        pwrite;
    logic [31:0] pwdata;
    logic        pready;
    logic [31:0] prdata;
    logic        pslverr;

endinterface