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
        wait(aresetn);
        repeat(7) begin
            @(posedge clk);
            A <= $urandom_range(0, 10);
            B <= $urandom_range(0, 10);
        end
        $stop();
    end

endmodule
