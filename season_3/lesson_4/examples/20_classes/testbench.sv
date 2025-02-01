module testbench;

    class packet;
        rand  bit [7:0] addr;
        constraint addr1_c { addr > 10; }
        constraint addr2_c { addr < 5; }
    endclass

    initial begin
        packet pkt;
        pkt = new();
        if( !pkt.randomize() )
            $error("Can't randomize packet!");
    end

endmodule

