module array_alu
    import array_alu_pkg::*;
(

    input  logic        clk,
    input  logic        aresetn,
    
    // ** APB

    input  logic [31:0] paddr,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] pwdata,
    output logic        pready,
    output logic [31:0] prdata,
    output logic        pslverr,

    // ** AXI4

    // Write address
    input  logic        awvalid,
    output logic        awready,
    input  logic [31:0] awaddr,

    // Write data
    input  logic        wvalid,
    output logic        wready,
    input  logic [31:0] wdata,

    // Write response
    output logic        bvalid,
    output logic [ 2:0] bresp,
    input  logic        bready,

    // Read address
    input  logic        arvalid,
    output logic        arready,
    input  logic [ 2:0] arid,
    input  logic [31:0] araddr,

    // Read data
    output logic        rvalid,
    input  logic        rready,
    output logic [ 2:0] rid,
    output logic [31:0] rdata,
    output logic [ 2:0] rresp

);


    op_t  apb2axi_op;
    logic apb2axi_start;
    logic axi2apb_done;

    // ** APB

    array_alu_apb apb_inst (
        .clk        ( clk           ),
        .aresetn    ( aresetn       ),
        // APB
        .paddr      ( paddr         ),
        .psel       ( psel          ),
        .penable    ( penable       ),
        .pwrite     ( pwrite        ),
        .pwdata     ( pwdata        ),
        .pready     ( pready        ),
        .prdata     ( prdata        ),
        .pslverr    ( pslverr       ),
        // Control-status
        .op         ( apb2axi_op    ),
        .start      ( apb2axi_start ),
        .done       ( axi2apb_done  )
    );


    // * AXI4

    array_alu_axi4 axi4_inst (
        .clk        ( clk           ),
        .aresetn    ( aresetn       ),
        // AXI4
        .awvalid    ( awvalid       ),
        .awready    ( awready       ),
        .awaddr     ( awaddr        ),
        .wvalid     ( wvalid        ),
        .wready     ( wready        ),
        .wdata      ( wdata         ),
        .bvalid     ( bvalid        ),
        .bresp      ( bresp         ),
        .bready     ( bready        ),
        .arvalid    ( arvalid       ),
        .arready    ( arready       ),
        .arid       ( arid          ),
        .araddr     ( araddr        ),
        .rvalid     ( rvalid        ),
        .rready     ( rready        ),
        .rid        ( rid           ),
        .rdata      ( rdata         ),
        .rresp      ( rresp         ),
        // Control-status
        .op         ( apb2axi_op    ),
        .start      ( apb2axi_start ),
        .done       ( axi2apb_done  )
    );


endmodule
