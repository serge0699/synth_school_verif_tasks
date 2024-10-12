`timescale 1ns/100ps;

module timescale_test;

    logic [7:0] a;

    initial begin
        a = 5;
        #1;    a = 2; // 1ns    = 1000ps - good
        #1.1;  a = 3; // 2.1ns  = 2100ps - good
        #1.04; a = 4; // 3.14ns = 3140ps - bad
        #1;
    end

endmodule

$display(i);