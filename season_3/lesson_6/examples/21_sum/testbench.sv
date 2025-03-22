module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] c;

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
        a <= 7'h1;
        b <= 7'h1;
        @(posedge clk);
        a <= 7'h3;
        b <= 7'h2;
        @(posedge clk);
        a <= 7'h4;
        @(posedge clk);
        $finish();
    end

    // Покрытие
    covergroup sum_cg (
        int l = 0, m = 1, n = 2, k = 3
    ) @(posedge clk);
        a_cp: coverpoint a {
            bins b1 = {[4:5]};
        }
        b_cp: coverpoint b {
            bins b1 = {[10:20]};
        }
    endgroup

    sum_cg cg1 = new();
    sum_cg cg2 = new(4, 5, 10, 20);

endmodule
