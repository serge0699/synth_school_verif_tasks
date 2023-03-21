module testbench;

    `include "riscv_instr.sv"

    // Instruction class

    riscv_instr instr;

    // Valid randomization field

    bit valid;

    // Some random instruction fields for disasm

    bit [ 4:0] shamt;
    bit [ 4:0] rs1;
    bit [ 4:0] rs2;
    bit [ 4:0] rd;
    bit [12:0] imm;
    bit [31:0] bin;

    // Define for randomization
    //   1) Randomize with 'WITH' argument constraints
    //   2) Print randomize status
    //   3) Print instruction with optional code in 'PRINT_COND'

    `define RAND_AND_PRINT(WITH=, PRINT_COND=if(1)) \
        valid = instr.randomize() with {WITH}; \
        $display("Is randomize valid: %1b", valid); \
        PRINT_COND instr.print();

    // Main generator testing

    initial begin

        // Create instruction

        instr = new();

        // Randomize ADD instruction by name
        // Check randomized fields

        $display("\n\n*** ADD instruction randomize");

        repeat(5) begin
            `RAND_AND_PRINT(name == ADDI;);
        end

        // Disasm SRAI instruction by its binary representation
        // Check if name and fields were set correctly for SRAI?
        // Compare with RISC-V specification

        $display("\n\n*** SRAI instruction disasm");

        repeat(5) begin
            void'(std::randomize(shamt, rs1, rd));
            `RAND_AND_PRINT(binary == {7'b0100000, shamt, rs1, 3'b101, rd, 7'b0010011};);
        end

        // Randomize BEQ instruction by name
        // Check randomized fields

        $display("\n\n*** BEQ instruction randomize");

        repeat(5) begin
            `RAND_AND_PRINT(name == BEQ;);
        end

        // Some random instruction disasm
        // No restrictions on binary, so some randomizations may be 
        // invalid. Check fields and name if randomization was valid
        // Compare with RISC-V specification

        $display("\n\n*** Random instruction disasm");

        repeat(20) begin
            // Set valid 'opcode' in binary to improve chances of valid randomization
            void'(std::randomize(bin) with {bin[6:0] == 7'b0010011;});
            `RAND_AND_PRINT(binary == bin;, if(valid));
        end

    end

endmodule