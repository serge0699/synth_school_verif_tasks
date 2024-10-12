`timescale 1ns/1ps;

module testbench;

    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] c;

    sum DUT(
        .a ( a ),
        .b ( b ),
        .c ( c )
    );

    initial begin
        a = 'x; b = 'x;
        #10; b = 2;
        #10; a = 1;
        #20; a = 5;
        #40; a = 7; b = 4;
        #30; a = 9;
        #10;
        $stop();
    end

endmodule
