// Address generator
module addr_gen 
#(  parameter MAX_DATA=16
) ( input en, clk, rst,
    output reg [3:0] addr
);
    initial addr <= 0;

    // Async reset
    // Increment address when enabled
    always @(posedge clk or posedge rst)
        if (rst)
            addr <= 0;
        else if (en) begin
            if (addr == MAX_DATA-1)
                addr <= 0;
            else
                addr <= addr + 1;
        end
endmodule

// Define our top level fifo entity
module fifo 
#(  parameter MAX_DATA=16
) ( input  logic       wen,
    input  logic       ren,
    input  logic       clk,
    input  logic       rst,
    input  logic       lock,
    input  logic [7:0] wdata,
    output logic [7:0] rdata,
    output logic [4:0] count,
    output logic       full,
    output logic       empty
);
    wire wskip, rskip;
    reg [4:0] data_count;

    // Fifo storage
    // Async read, sync write
    wire [3:0] waddr, raddr;
    reg [7:0] data [MAX_DATA-1:0];
    always @(posedge clk)
        if (wen) 
            data[waddr] <= wdata;
    assign rdata = !lock ? data[raddr] : 8'b0;

    // Address generator for both
    // write and read addresses
    addr_gen #(.MAX_DATA(MAX_DATA))
    fifo_writer (
        .en     (wen || wskip),
        .clk    (clk  ),
        .rst    (rst),
        .addr   (waddr)
    );

    addr_gen #(.MAX_DATA(MAX_DATA))
    fifo_reader (
        .en     (ren || rskip),
        .clk    (clk  ),
        .rst    (rst),
        .addr   (raddr)
    );

    // Status signals
    initial data_count <= 0;

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_count <= 0;
        else if (wen && !ren)
            data_count <= data_count + 1;
        else if (ren && !wen && data_count > 0)
            data_count <= data_count - 1;
    end

    assign full  = data_count == MAX_DATA;
    assign empty = (data_count == 0) && ~rst;
    assign count = data_count;

    // Write while full => overwrite oldest data, move read pointer
    assign rskip = 0;
    // Read while empty => read invalid data, keep write pointer in sync
    assign wskip = ren && !wen && data_count == 0;

    // Tests
    always @(posedge clk) begin
        if (~rst) begin
            was_empty    : cover(empty);
            was_full     : cover(full);
            was_not_empty: cover(!empty);
            was_not_full : cover(!full);
        end
    end
    generate
        genvar i;
        for(i = 0; i <= 4; i++) begin
            always @(posedge clk) begin
                if (~rst) begin
                    cover(wdata[i]);
                end
            end
        end
    endgenerate
    always @(posedge clk) begin
        if (rst) begin
            a_zero_out: assert(!empty && !full && !count);
        end
    end
    always @(posedge clk) begin
        if (~rst) begin
            w_full: cover (wen && !ren && count == MAX_DATA-1);
            r_empty: cover (ren && !wen && count == 1);
        end
    end
    always @(posedge clk) begin
        if (rst) begin
            a_zero_addr: assert (!waddr && !raddr);
        end
    end
    always @(posedge clk) begin
        if (~rst) begin
            count_oflow: assert (count <= MAX_DATA);
        end
    end

endmodule
