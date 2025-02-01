module testbench;

    class packet;
        rand  bit [7:0] addr;
        constraint addr1_c { addr > 10; }
    endclass

    initial begin
        packet pkt;
        pkt = new();
        if( !pkt.randomize() with {addr < 5;} )
            $error("Can't randomize packet!");
    end

endmodule

