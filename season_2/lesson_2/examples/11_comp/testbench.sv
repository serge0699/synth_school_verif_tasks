module testbench;

    // Массив
    int data;

    // Количество итераций
    int iters;

    // Генерация через std::randomize()
    `ifdef URANDOM
        initial begin
            $value$plusargs("iters=%0d", iters);
            repeat(iters) begin
                data = $urandom_range(5124214, 14414214);
            end
            $stop();
        end
    `else
        initial begin
            $value$plusargs("iters=%0d", iters);
            $display(iters);
            repeat(iters) begin
                void'(std::randomize(data) with {data inside {[5124214:14414214]};});
            end
            $stop();
        end
    `endif

endmodule
