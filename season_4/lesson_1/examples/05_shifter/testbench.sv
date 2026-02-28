`timescale 1ns/1ps;

module testbench;

    logic [7:0] a;
    logic [2:0] b;
    logic [7:0] c;

    shifter DUT(
        .a ( a ),
        .b ( b ),
        .c ( c )
    );

    initial begin
             a =      'x; b =   'x;
        #10; a = 8'b0001; b = 3'd7;
        #10;              b = 3'd3;
        #10;              b = 3'd1;
        #10; a = 8'b1000; b = 3'd7;
        #10;              b = 3'd3;
        #10;
        $stop();
    end

endmodule
