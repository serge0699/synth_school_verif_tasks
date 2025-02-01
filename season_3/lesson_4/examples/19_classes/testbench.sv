module testbench;

    class packet;
        rand  bit [7:0] addr;
        constraint addr_c { addr > 2; }
    endclass

    initial begin
        packet pkt;
        pkt = new();
        repeat(10) begin
          pkt.randomize() with {addr < 5;};
          $display("pkt.addr = %0d", pkt.addr);
        end
    end

endmodule

