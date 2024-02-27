module mem (
    input  logic        clk,
    input  logic        mem_req,
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic [ 7:0] mem_addr,
    output logic        mem_ack,
    output logic        mem_err,
    output logic [31:0] mem_data
);

    // request
    initial begin
        logic read, write;
        mem_ack  <= 0;
        mem_err  <= 0;
        mem_data <= 0;
        @(posedge clk);
        forever begin
            while(!mem_req) @(posedge clk);
            {read, write} = {mem_read, mem_write};
            // delay
            if( mem_addr < 64 ) repeat($urandom_range(0, 4)) @(posedge clk);
            else repeat($urandom_range(5, 7)) @(posedge clk);
            // ack
            mem_ack <= 1;
            // error
            mem_err <= $urandom_range(0, 1);
            // data
            if( read ) mem_data <= $urandom_range(0, 128);
            else mem_data <= 'x;
            @(posedge clk);
            mem_ack  <=  0;
            mem_err  <=  0;
            mem_data <= 'x;
        end
    end

endmodule