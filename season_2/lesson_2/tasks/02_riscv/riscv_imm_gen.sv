module riscv_imm_gen (
    input  logic        clk,
    input  logic        aresetn,
    input  logic [31:0] instr,
    output logic [31:0] i_imm,
    output logic [31:0] s_imm,
    output logic [31:0] b_imm,
    output logic [31:0] u_imm,
    output logic [31:0] j_imm
);

    logic [31:0] i_imm_w;
    logic [31:0] s_imm_w;
    logic [31:0] b_imm_w;
    logic [31:0] u_imm_w;
    logic [31:0] j_imm_w;

    assign i_imm_w = { { ( 20 ){ instr[31] } }, instr[30:20] };
    assign s_imm_w = { { ( 20 ){ instr[31] } }, instr[7], instr[30:25], instr[11:8],  1'b0 };
    assign b_imm_w = { { ( 21 ){ instr[31] } }, instr[30:25], instr[11:8],  instr[7] };
    assign u_imm_w = { instr[31:12], { ( 11 ){ 1'b0 } } };
    assign j_imm_w = { { ( 20 ){ instr[31] } }, instr[19:12], instr[20], instr[24:21], 1'b0 };

    logic [31:0] i_imm_ff;
    logic [31:0] s_imm_ff;
    logic [31:0] b_imm_ff;
    logic [31:0] u_imm_ff;
    logic [31:0] j_imm_ff;

    always_ff @( posedge clk or negedge aresetn ) begin
        if(!aresetn) begin
            i_imm_ff <= 32'b0;
            s_imm_ff <= 32'b0;
            b_imm_ff <= 32'b0;
            u_imm_ff <= 32'b0;
            j_imm_ff <= 32'b0;
        end
        else begin
            i_imm_ff <= i_imm_w;
            s_imm_ff <= s_imm_w;
            b_imm_ff <= b_imm_w;
            u_imm_ff <= u_imm_w;
            j_imm_ff <= j_imm_w;
        end
    end

    assign i_imm = i_imm_ff;
    assign s_imm = s_imm_ff;
    assign b_imm = b_imm_ff;
    assign u_imm = u_imm_ff;
    assign j_imm = j_imm_ff;

endmodule