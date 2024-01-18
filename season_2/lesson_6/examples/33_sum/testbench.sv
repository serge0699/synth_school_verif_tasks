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
        }
        b_cp: coverpoint b {
            bins b1 [5] = {[1:5]};
        }
    endgroup

    covergroup sum_cg_2 @(posedge clk);
        a_cp: coverpoint a {
            bins b1 = {32'hFFFFFFFF};
        }
    endgroup

    sum_cg   cg;
    sum_cg_2 cg_2;
    sum_cg_2 cg_3;

    initial begin
        cg   = new();
        cg_2 = new();
        cg_3 = new();
        cg.option.goal = 50;
        cg.a_cp.option.goal = 0;
        cg.option.name = "cg";
        // cg.a_cp.option.name = "a_cp";
    end

endmodule
