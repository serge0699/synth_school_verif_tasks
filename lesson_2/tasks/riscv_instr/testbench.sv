module testbench;

    `include "riscv_instr.sv"

    riscv_instr instr;

    initial begin
        bit valid;
        instr = new(SRAI);
        repeat(10) begin
            valid = instr.randomize();
            $display("Is randomize valid: %1b", valid);
            instr.print();
        end
    end


endmodule