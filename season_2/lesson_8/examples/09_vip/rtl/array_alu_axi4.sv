module array_alu_axi4
    import array_alu_pkg::*;
(
    input  logic        clk,
    input  logic        aresetn,
    // AXI4
    input  logic        awvalid,
    output logic        awready,
    input  logic [31:0] awaddr,
    input  logic        wvalid,
    output logic        wready,
    input  logic [31:0] wdata,
    output logic        bvalid,
    output logic [ 2:0] bresp,
    input  logic        bready,
    input  logic        arvalid,
    output logic        arready,
    input  logic [ 2:0] arid,
    input  logic [31:0] araddr,
    output logic        rvalid,
    input  logic        rready,
    output logic [ 2:0] rid,
    output logic [31:0] rdata,
    output logic [ 2:0] rresp,
    // Control-status
    input  op_t         op,
    input  logic        start,
    output logic        done
);

    // AXI4 transaction

    class array_alu_axi4_trans;

        logic [31:0] awaddr;
        logic [31:0] wdata;
        logic [ 2:0] bresp;
        logic [ 2:0] arid;
        logic [31:0] araddr;
        logic [ 2:0] rid;
        logic [ 2:0] rresp;
        logic [31:0] rdata;

    endclass

    // Queues for phases

    array_alu_axi4_trans wa [$];
    array_alu_axi4_trans wd [$];
    array_alu_axi4_trans r  [$];
    array_alu_axi4_trans ra [$];
    array_alu_axi4_trans rd [$];

    // Another registers

    int unsigned a_reg [4], b_reg [4], c_reg [4];

    // Write address

    task automatic write_address();

        array_alu_axi4_trans tr;

        forever begin

            // Random delay for ready
            repeat($urandom_range(0, 10)) begin
                @(posedge clk);
            end
            awready <= 1;
            @(posedge clk);

            // If valid transaction - save
            if( awvalid ) begin
                tr = new();
                tr.awaddr  = awaddr;
                wa.push_back(tr);
            end

            // Zero ready
            awready <= 0;
            if( awvalid ) break;

        end

    endtask

    // Write data

    task automatic write_data();

        array_alu_axi4_trans tr;

        forever begin

            // Random delay for ready
            repeat($urandom_range(0, 10)) begin
                @(posedge clk);
            end
            wready <= 1;
            @(posedge clk);

            // If valid transaction - save
            if( wvalid ) begin
                tr = new();
                tr.wdata = wdata;
                wd.push_back(tr);
            end

            // Zero ready
            wready <= 0;
            if( wvalid ) break;

        end

    endtask

    // Write data depending on transaction fields

    task automatic write_data_item(array_alu_axi4_trans tr);

        logic [2:0] resp;

        // If invalid address - set error
        if( !(tr.awaddr inside {
            A0, A1, A2, A3,
            B0, B1, B2, B3,
            C0, C1, C2
        } ) ) resp = 3'b010; // SLVERR
        // Else set OKAY
        else resp = 3'b000; // OKAY

        // Write data
        case(tr.awaddr)
            A0     : a_reg [0] <= tr.wdata;
            A1     : a_reg [1] <= tr.wdata;
            A2     : a_reg [2] <= tr.wdata;
            A3     : a_reg [3] <= tr.wdata;
            B0     : b_reg [0] <= tr.wdata;
            B1     : b_reg [1] <= tr.wdata;
            B2     : b_reg [2] <= tr.wdata;
            B3     : b_reg [3] <= tr.wdata;
            C0     : c_reg [0] <= tr.wdata;
            C1     : c_reg [1] <= tr.wdata;
            C2     : c_reg [2] <= tr.wdata;
            C3     : c_reg [3] <= tr.wdata;
            default: ;
        endcase

        // Execute response channel routine
        write_resp(resp);

    endtask

    // Write response

    task automatic write_resp(logic [2:0] resp);

        // Random delay for bvalid
        repeat($urandom_range(0, 10)) begin
            @(posedge clk);
        end
        bvalid <= 1;
        bresp  <= resp;
        @(posedge clk);

        // Wait for bready
        while( !bready ) begin
            @(posedge clk);
        end

        // Zero valid
        bvalid <= 0;

    endtask

    // Read address

    task automatic read_address();

        array_alu_axi4_trans tr;

        forever begin

            // Random delay for ready
            repeat($urandom_range(0, 10)) begin
                @(posedge clk);
            end
            arready <= 1;
            @(posedge clk);

            // If valid transaction - save
            if( arvalid ) begin
                tr = new();
                tr.araddr  = araddr;
                tr.arid    = arid;
                ra.push_back(tr);
            end

            // Zero ready
            arready <= 0;
            if( arvalid ) break;

        end

    endtask

    // Read data

    task automatic read_data();

        array_alu_axi4_trans tr;

        // We wait for some amount of transactions
        // or at least one transaction and 100 cycles
        // after it

        fork begin
            fork
                wait(ra.size() >= $urandom_range(1, 5));
                begin
                    wait(ra.size());
                    repeat(100) @(posedge clk);
                end
            join_any
            disable fork;
        end join
        
        // Now lets process every transaction out of order
        ra.shuffle();
        read_data_items(ra.size());
        
    endtask

    // Read specified amount of items

    task automatic read_data_items(int unsigned num);

        array_alu_axi4_trans tr;
        
        repeat(num) begin

            // Get transaction from queue
            tr = ra.pop_front();

            // Random delay for bvalid
            repeat($urandom_range(0, 10)) begin
                @(posedge clk);
            end
            rvalid <= 1;
            read_data_item(tr);
            @(posedge clk);

            // Wait for bready
            while( !rready ) begin
                @(posedge clk);
            end

            // Zero valid
            rvalid <= 0;

        end

    endtask

    // Set read data signals depending on address

    task automatic read_data_item(array_alu_axi4_trans tr);

        // Set valid
        rvalid <= 1;

        // If invalid address - set error
        if( !(tr.araddr inside {
            A0, A1, A2, A3,
            B0, B1, B2, B3,
            C0, C1, C2, C3
        } ) ) rresp <= 3'b010; // SLVERR
        // Else set OKAY
        else rresp <= 3'b000; // OKAY

        // Set rdata
        case(tr.araddr)
            A0     : rdata <= a_reg [0];
            A1     : rdata <= a_reg [1];
            A2     : rdata <= a_reg [2];
            A3     : rdata <= a_reg [3];
            B0     : rdata <= b_reg [0];
            B1     : rdata <= b_reg [1];
            B2     : rdata <= b_reg [2];
            B3     : rdata <= b_reg [3];
            C0     : rdata <= c_reg [0];
            C1     : rdata <= c_reg [1];
            C2     : rdata <= c_reg [2];
            C3     : rdata <= c_reg [3];
            default: rdata <= 'x;
        endcase

        // Set rid
        rid <= tr.arid;

    endtask

    // Main calculation behaviour

    initial begin
        op_t op_start;
        forever begin
            @(posedge start);
            // Execute operation only if
            // not in reset
            if( aresetn ) begin
                // Get operation when
                // the start is raised
                op_start = op;
                // Do operation after
                // some cycles
                repeat($urandom_range(50, 100)) begin
                    @(posedge clk);
                end
                exec_op(op_start);
                done <= 1;
                @(posedge clk);
                done <= 0;
            end
        end
    end

    // Execute operation
    
    function void exec_op(op_t op_start);
        case(op_start)
            ADD    : foreach(c_reg[i]) c_reg[i] = a_reg[i] + b_reg[i];
            SUB    : foreach(c_reg[i]) c_reg[i] = a_reg[i] - b_reg[i];
            MUL    : foreach(c_reg[i]) c_reg[i] = a_reg[i] * b_reg[i];
            // If wrong operation - do nothing
            default: ;
        endcase
    endfunction

    // Main AXI4 logic

    initial begin
        forever begin
            fork
                axi4_main();
            join_none
            wait(!aresetn);
            disable fork;
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            arready <= 0;
            rvalid  <= 0;
            wait(aresetn);
        end
    end

    task automatic axi4_main();
        array_alu_axi4_trans tr_wa, tr_wd;
        fork
            // Write
            forever write_address();
            forever write_data   ();
            forever begin
                wait( wa.size() && wd.size() );
                tr_wa = wa.pop_front();
                tr_wd = wd.pop_front();
                // Compile final transaction
                tr_wa.wdata = tr_wd.wdata;
                // Write and execute response
                write_data_item(tr_wa);
            end
            // Read
            forever read_address();
            forever read_data   ();
        join
    endtask


endmodule