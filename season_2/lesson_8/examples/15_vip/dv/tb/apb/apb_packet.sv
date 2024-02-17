class apb_packet_base;

    rand logic [31:0] paddr;
    rand logic        pwrite;
    rand logic [31:0] pwdata;
    rand logic [31:0] prdata;
    rand logic        pslverr;

    // Useful function for print

    virtual function string convert2string();
        string str;
        str = {str, $sformatf("paddr  : %8h\n", paddr  )};
        str = {str, $sformatf("pwrite : %1b\n", pwrite )};
        str = {str, $sformatf("pwdata : %8h\n", pwdata )};
        str = {str, $sformatf("prdata : %8h\n", prdata )};
        str = {str, $sformatf("pslverr: %1b\n", pslverr)};
        return str;
    endfunction

endclass