class axi4_packet_base;

    // Transaction channel
    rand axi4_channel_t channel;

    // Data
    rand logic  [31:0] awaddr;
    rand logic  [31:0] wdata;
    rand logic  [ 2:0] bresp;
    rand logic  [ 2:0] arid;
    rand logic  [31:0] araddr;
    rand logic  [ 2:0] rid;
    rand logic  [ 2:0]  rresp;
    rand logic  [31:0] rdata;

    // Constraint channel
    constraint channel_c {
        channel inside {AW, W, AR};
    }

    // Useful function for print

    virtual function string convert2string();
        string str;
        str = {str, $sformatf("awaddr: %8h\n", awaddr)};
        str = {str, $sformatf("wdata : %8h\n", wdata )};
        str = {str, $sformatf("bresp : %3b\n", bresp )};
        str = {str, $sformatf("arid  : %3b\n", arid  )};
        str = {str, $sformatf("araddr: %8h\n", araddr)};
        str = {str, $sformatf("rid   : %3b\n", rid   )};
        str = {str, $sformatf("rresp : %3b\n", rresp )};
        str = {str, $sformatf("rdata : %8h\n", rdata )};
        return str;
    endfunction

endclass