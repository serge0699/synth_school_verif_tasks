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

    // Процессы для A и B
    process a_p, b_p;

    // Генерация входных сигналов

    initial begin
        a_p = process::self();
        $display(a_p.get_randstate());
        wait(aresetn);
        @(posedge clk);
        A <= $urandom();
        @(posedge clk);
        A <= $urandom();
        @(posedge clk);
        A <= $urandom();
        @(posedge clk);
        A <= $urandom();
        @(posedge clk);
        A <= $urandom();
        @(posedge clk);
        A <= $urandom();
        @(posedge clk);
        $stop();
    end

    initial begin
        b_p = process::self();
        $display(b_p.get_randstate());
        wait(aresetn);
        @(posedge clk);
        B <= $urandom();
        @(posedge clk);
        B <= $urandom();
        @(posedge clk);
        B <= $urandom();
        @(posedge clk);
        B <= $urandom();
        @(posedge clk);
        B <= $urandom();
        @(posedge clk);
        B <= $urandom();
        @(posedge clk);
    end

endmodule
