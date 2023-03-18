// This variable define some RISC-V instructions

typedef enum { 
    ADDI,
    SLTI,
    SLTIU,
    ORI,
    XORI,
    ANDI,
    SLLI,
    SRLI,
    SRAI
} riscv_instr_name_e;

// Main instruction class

class riscv_instr;

    // Instruction fields

    // TODO: Create instruction fields with 'rand bit' type
    //       Create only for declared in 'riscv_instr_name_e' type
    // 
    // Example: rand bit [ 6:0] opcode;

    // There must be 'opcode', 'rd', 'funct3', 'rs1', 'imm'


    // Instruction name

    riscv_instr_name_e name;

    function new(riscv_instr_name_e name);
        this.name = name;
    endfunction

    // TODO: write 'opcode' constraint
    //       'opcode' must be 7'b0010011 for defined instructions


    // TODO: write 'rd' constraint
    //       Can it be empty?


    // funct3 constraint, NOTE: this constraint uses function

    constraint funct3_c { funct3 == get_funct3(); }

    // rs1 constraint, can be empty as all values are legal

    constraint rs1_c { }

    // TODO: write 'imm' constraint, use functions encodings


    // TODO: extend case in this function

    virtual function bit [2:0] get_funct3();
        bit [2:0] funct3;
        case(name)
            ADDI   : funct3 = 3'b000;
            SLTI   : funct3 = 3'b010;
            // Check all cases here
            default: $display("Invalid name %s", name.name());
        endcase
        return funct3;
    endfunction

    // print instruction

    virtual function void print();
        $display("Name: %s\n opcode: %7b\n rd: %5b\n funct3: %3b\n rs1: %5b\n imm: %12b",
            name.name(), opcode, rd, funct3, rs1, imm);
    endfunction

endclass