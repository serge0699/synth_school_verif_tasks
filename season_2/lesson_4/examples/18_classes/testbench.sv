module testbench;

    class packet;
        rand  bit addr1;
        rand  bit addr2;
        constraint addr_c { unique {addr1, addr2};}
    endclass

    initial begin
        packet pkt;
        pkt = new();
        repeat(10) begin
          pkt.randomize();
          $display("pkt.addr1 = %0d", pkt.addr1);
          $display("pkt.addr2 = %0d", pkt.addr2);
        end
    end

endmodule

