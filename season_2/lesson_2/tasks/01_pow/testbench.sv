`timescale 1ns/1ps

module testbench;

    logic        clk;
    logic [31:0] A;
    logic [31:0] B;

    pow DUT(
        .clk ( clk ),
        .a   ( A   ),
        .b   ( B   )
    );

    `include "checker.svh"

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = // ?;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            // Пишите тут.
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    initial begin

        logic [31:0] A_tmp;

        // TODO:
        // Сгенерируйте несколько чисел в интервале от 0 до 25.
        // Используйте цикл + @(posedge clk).


        -> done_100;

        // TODO:
        // Сгенерируйте несколько только четных чисел.
        // Используйте цикл + @(posedge clk).
        // Подумайте, как сделать число четным после рандомизации.


        -> done_2;

        // TODO:
        // Сгенерируйте несколько чисел чисел, которые делятся на 3
        // без остатка.
        // Используйте цикл + @(posedge clk).
        // Здесь нужно рандомизировать число, пока не выполнится
        // условие деления на 3 без остатка: <число> % 3 == 0.


        -> done_3;

    end

endmodule
