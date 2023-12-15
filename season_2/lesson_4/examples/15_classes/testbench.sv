module testbench;

    class packet;
        rand  bit [3:0] addr;
        constraint addr_c { addr > 5;
                            addr % 2 == 0;
                            addr < 10; }
    endclass

    initial begin
          packet pkt;
          pkt = new();
          repeat(10) begin
            pkt.randomize();
            $display("pkt.addr = %0d", pkt.addr);
          end
    end

endmodule
