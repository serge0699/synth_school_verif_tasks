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
        #5; if( c !== 'x ) $error("BAD");
        #5;
        b = 2;
        #5; if( c !== 'x ) $error("BAD");
        #5;
        a = 1;
        #5; if( c !== 3 ) $error("BAD");
        #15;
        a = 5;
        #5; if( c !== 7 ) $error("BAD");
        #35;
        a = 7; b = 4;
        #5; if( c !== 11 ) $error("BAD");
        #25; a = 9;
        #5; if( c !== 13 ) $error("BAD");
        #5;
        $stop();
    end

endmodule
