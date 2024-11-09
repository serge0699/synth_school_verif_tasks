module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] A;
    logic [7:0] B;
    logic       C;

    comp DUT(
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
        logic [7:0] A_t, B_t;
        wait(aresetn);
        repeat(100) begin
            @(posedge clk);
            void'(std::randomize(A_t, B_t) with {A_t < B_t;});
            A <= A_t;
            B <= B_t;
        end
        repeat(100) begin
            @(posedge clk);
            void'(std::randomize(A_t, B_t) with {A_t > B_t;});
            A <= A_t;
            B <= B_t;
        end
        repeat(100) begin
            @(posedge clk);
            void'(std::randomize(A_t, B_t) with {A_t == B_t;});
            A <= A_t;
            B <= B_t;
        end
        $stop();
    end

endmodule
