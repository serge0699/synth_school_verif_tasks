package array_alu_pkg;

    typedef enum logic [31:0]{
        OP    = 32'h0,
        START = 32'h4,
        DONE  = 32'h8,
        A0    = 32'hC,
        A1    = 32'h10,
        A2    = 32'h14,
        A3    = 32'h18,
        B0    = 32'h1c,
        B1    = 32'h20,
        B2    = 32'h24,
        B3    = 32'h28,
        C0    = 32'h2C,
        C1    = 32'h30,
        C2    = 32'h34,
        C3    = 32'h38
    } array_alu_regs_t;

    typedef enum logic [1:0] {
        ADD = 2'b00,
        SUB = 2'b01,
        MUL = 2'b10
    } op_t;

endpackage