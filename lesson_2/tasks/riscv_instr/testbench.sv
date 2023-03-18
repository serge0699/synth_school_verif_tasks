module testbench;

    `include "riscv_instr.sv"

    riscv_instr instr;

    // TODO: check instructions
    // 
    // Example for SRAI:

    initial begin
        bit valid;
        instr = new(SRAI);
        repeat(10) begin
            valid = instr.randomize();
            $display("Is randomize valid: %1b", valid);
            instr.print();
        end
    end

    //                   ^
    //                   |    
    // TODO: Write the same blocks for some instructions


endmodule