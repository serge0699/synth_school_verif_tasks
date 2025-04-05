module array_alu_apb
    import array_alu_pkg::*;
(
    input  logic        clk,
    input  logic        aresetn,
    // APB
    input  logic [31:0] paddr,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] pwdata,
    output logic        pready,
    output logic [31:0] prdata,
    output logic        pslverr,
    // Control-status
    output op_t         op,
    output logic        start,
    input  logic        done
);

    // Registers

    int unsigned op_reg, start_reg, done_reg;

    // Update DONE register from outside
    // Check strobe only

    initial begin
        forever begin
            @(posedge done);
            @(posedge clk);
            // Update DONE if not in reset
            if( aresetn )
                done_reg <= 1;
        end
    end

    // Main APB logic

    initial begin
        forever begin
            fork
                apb_main();
            join_none
            wait(!aresetn);
            disable fork;
            pready <= 0;
            wait(aresetn);
        end
    end

    task automatic apb_main();
        bit broken;
        pready <= 0;
        forever begin
            @(posedge clk);
            // If PSEL - start transaction
            if( psel ) begin
                @(posedge clk);
                if( penable ) begin
                    repeat($urandom_range(0, 9)) begin
                        if( !psel || !penable ) broken = 1;
                        @(posedge clk);
                    end
                    // If PSEL or PENABLE was 0 before
                    // PREADY - skip transaction
                    if( broken ) begin
                        broken = 0;
                    end
                    else begin
                        pready <= 1;
                        exec_trans();
                    end
                    @(posedge clk);
                    pready <= 0;
                end
            end
        end
    endtask

    // Task for checking transaction and sending
    // stimulus back to the master

    task automatic exec_trans();
        if( pwrite ) begin
            // If write and register not OP or START
            if( !(paddr inside {OP, START}) ) begin
                pslverr <= 1;
            end
            // If invalid operation in OP
            else if( (paddr == OP                     ) &&
                    !(pwdata inside {ADD, SUB, MUL}) ) begin
                pslverr <= 1;
            end
            // Else write
            else begin
                if( paddr == OP ) begin
                    op_reg = pwdata;
                    op = op_t'(pwdata);
                end
                else begin
                    start_reg = pwdata;
                    // Do strobe on start
                    fork
                        begin
                            start <= 1;
                            @(posedge clk);
                            start <= 0;
                        end
                    join_none
                end
            end
        end
        else begin
            // If read and register not OP or DONE
            if( !(paddr inside {OP, DONE}) ) begin
                pslverr <= 1;
            end
            // Else read
            else begin
                if( paddr == OP ) begin
                    prdata <= op_reg;
                end
                else begin
                    prdata <= done_reg;
                    // Reset done register after read
                    done_reg <= 0;
                end
            end
        end
    endtask


endmodule