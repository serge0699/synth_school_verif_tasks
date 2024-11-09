module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] C;

    sum DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( A       ),
        .b       ( B       ),
        .c       ( C       )
    );

    // Период тактового сигнала
    parameter CLK_PERIOD = 10;

    // Генерация тактового сигнала
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    // Генерация сигнала сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // Генерация входных сигналов
    initial begin
        logic [31:0] A_t, B_t;
        wait(aresetn);
        repeat(7) begin
            @(posedge clk);
            if( !std::randomize(A_t) with {A_t inside {[0:10]};} )
                $error("A was not randomized!");
            void'(std::randomize(B_t) with {B_t inside {[0:10]};});
            A <= A_t;
            B <= B_t;
        end
        $stop();
    end

endmodule
