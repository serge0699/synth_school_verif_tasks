module testbench;

    parameter CLK_PERIOD = 10;

    logic        clk;
    logic        mem_req;
    logic        mem_read;
    logic        mem_write;
    logic [ 7:0] mem_addr;
    logic        mem_ack;
    logic        mem_err;
    logic [31:0] mem_data;

    // clk
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end

    // stimulus
    initial begin
        mem_req   <= 0;
        mem_read  <= 0;
        mem_write <= 0;
        mem_addr  <= '0;
        repeat(100) begin
            repeat($urandom_range(50, 100)) @(posedge clk);
            mem_req   <= 1;
            read_write();
            mem_addr  <= $urandom();
            @(posedge clk);
            mem_req   <= 0;
            mem_read  <= 0;
            mem_write <= 0;
            mem_addr  <= '0;
        end
        repeat(100) begin
            repeat($urandom_range(50, 100)) @(posedge clk);
            mem_req   <= 1;
            read_write(1);
            mem_addr  <= $urandom();
            @(posedge clk);
            mem_req   <= 0;
            mem_read  <= 0;
            mem_write <= 0;
            mem_addr  <= '0;
        end
    end

    task automatic read_write(bit can_interleave = 0);
        bit read, write;
        read = $urandom();
        if( can_interleave ) write = $urandom();
        else write = ~read;
        mem_read  <= read;
        mem_write <= write;
    endtask

    // finish
    initial begin
        repeat(200) @(posedge mem_ack);
        @(posedge clk);
        $finish();
    end

    // DUT
    mem DUT (
        .clk       ( clk       ),
        .mem_req   ( mem_req   ),  
        .mem_read  ( mem_read  ),  
        .mem_write ( mem_write ),  
        .mem_addr  ( mem_addr  ),  
        .mem_ack   ( mem_ack   ),  
        .mem_err   ( mem_err   ),  
        .mem_data  ( mem_data  )
    );

    // TODO: 
    // Напишите SVA, определяющий, что по любому
    // адресу, меньшему 64, запросы в память
    // завершаются не позднее, чем через 5 тактов
    // (то есть после 'mem_req', равного 1, 'mem_ack'
    // приходит не позднее, чем через 5 тактов).
    property pReqAckLow;
        @(posedge clk) (
            (mem_req && mem_addr < 64) |-> ##[0:5] mem_ack
        );
    endproperty

    apHandshake: assert property(pReqAckLow) begin
        $display("%0t Good %m!", $time());
    end else begin
        $display("%0t Bad %m!", $time());
        $stop();
    end

    // TODO:
    // Напишите SVA, определяющий, что при
    // запросе в память ('mem_req') не могут
    // быть одновременно выставлены в логическую
    // 1 'mem_read' и 'mem_write'.
    property pReadWrite;
        @(posedge clk) (
            not(mem_req && mem_read && mem_write)
        );
    endproperty

    apReadWrite: assert property(pReadWrite) begin
        $display("%0t Good %m!", $time());
    end else begin
        $display("%0t Bad %m!", $time());
        $stop();
    end

    // TODO:
    // Напишите SVA, определяющий, что ошибка 'mem_err'
    // не может появляться (принимать значение 1)
    // в ходе записи в память ('mem_write' && 'mem_req').
    property pErrWrite;
        @(posedge clk) (
            mem_req && mem_write |-> first_match(##[0:$] mem_ack) |-> !mem_err
        );
    endproperty

    apErrWrite: assert property(pErrWrite) begin
        $display("%0t Good %m!", $time());
    end else begin
        $display("%0t Bad %m!", $time());
        $stop();
    end

    // TODO:
    // Напишите SVA, определяющий, что при чтении из
    // памяти ('mem_read' && 'mem_req') сигнал 'mem_data'
    // при 'mem_ack', равном 1, не может принимать
    // неопределенное (X) значение.
    property pDataRead;
        @(posedge clk) (
            mem_req && mem_read |-> first_match(##[0:$] mem_ack) |-> !$isunknown(mem_data)
        );
    endproperty

    apDataRead: assert property(pDataRead) begin
        $display("%0t Good %m!", $time());
    end else begin
        $display("%0t Bad %m!", $time());
        $stop();
    end


    // TODO:
    // Определите, все ли написанные SVA выполняются в ходе
    // симуляции

endmodule
