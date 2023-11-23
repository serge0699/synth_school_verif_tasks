module initial_test;

    initial begin
        #5ns;
        $display("%0t: Initial 0", $time());
    end

    initial begin
        #10ns;
        $display("%0t: Initial 1", $time());
    end

endmodule
