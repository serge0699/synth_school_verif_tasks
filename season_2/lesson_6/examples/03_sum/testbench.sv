module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    sum DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( a       ),
        .b       ( b       ),
        .c       ( c       )
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
        @(posedge clk);
        a <= 32'h1;
        b <= 32'h1;
        @(posedge clk);
        a <= 32'h3;
        b <= 32'h2;
        @(posedge clk);
        a <= 32'h4;
        @(posedge clk);
        $finish();
    end

    // Покрытие
    covergroup sum_cg @(posedge clk);
        a_cp: coverpoint a {
            bins b1 [5] = {[1:5]};
            bins b2 = {3};
            bins b3 = {32'hFFFFFFFF};
        }
    endgroup

    sum_cg   cg;

    initial begin
        cg = new();
    end

endmodule
