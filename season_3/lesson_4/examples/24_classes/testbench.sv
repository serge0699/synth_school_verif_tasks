module testbench;

    class packet;
        rand int data [];
        constraint data_c {
            data.size() < 3;
        }
    endclass

    initial begin
        packet pkt;
        pkt = new();
        repeat(10) begin
          pkt.randomize();
          $display("%p", pkt.data);
        end
    end

endmodule

