// This variable define some RISC-V instructions

// TODO: add BEQ instruction and take this instruction
//       into account in constraints

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

    // There must be 'opcode', 'rd', 'funct3', 'rs1', 'rs2', 'imm'


    // TODO: Create full instruction binary with type 'rand bit'
    //       and name 'binary'


    // Instruction name

    rand riscv_instr_name_e name;


    // TODO: Write 'opcode' constraint
    //       'opcode' must be 7'b0010011 for all defined instructions,
    //       except BEQ (find BEQ opcode in specification)


    // TODO: Write 'rd' constraint
    //       Can it be empty?


    // TODO: Extend 'funct3' constraint with all
    //       instruction names from 'riscv_instr_name_e'

    constraint funct3_c { 
        name == ADDI  -> funct3 == 3'b000;
        name == SLTI  -> funct3 == 3'b010;
    }


    // 'rs1' constraint, can be empty as all values are legal

    constraint rs1_c { }


    // TODO: Write 'rs2' constraint
    //       Can it be empty?


    // TODO: Write 'imm' constraint, use functions encodings


    // TODO: Write 'binary' constraint, use fields concatenation


    // Print instruction

    virtual function void print();
        $display("----------------------------------------");
        $display(
            string'({" name  : %s\n opcode: %7b\n rd    : %5b\n funct3: %3b\n ",
                "rs1   : %5b\n rs2   : %5b\n imm   : %12b\n binary: %31b"}),
                    name.name(), opcode, rd, funct3, rs1, rs2, imm, binary
        );
        $display("----------------------------------------\n");
    endfunction

endclass