module mult (

    input logic         clk,
    input logic         aresetn,

    input  logic        s_tvalid,
    output logic        s_tready,
    input  logic [31:0] s_tdata,
    input  logic        s_tid,
    input  logic        s_tlast,

    output logic        m_tvalid,
    input  logic        m_tready,
    output logic [31:0] m_tdata,
    output logic        m_tid,
    output logic        m_tlast

);

    logic        tvalid_ff;
    logic [31:0] tdata_ff;
    logic        tid_ff;
    logic        tlast_ff;

    always_ff @(posedge clk or negedge aresetn) begin
        if( ~aresetn ) begin
            tvalid_ff    <= 'b0;
            tdata_ff     <= 'b0;
            tid_ff       <= 'b0;
            tlast_ff     <= 'b0;
        end
        else if ( s_tready ) begin
            tvalid_ff    <= s_tvalid;
            tdata_ff     <= s_tdata * s_tdata;
            tid_ff       <= s_tid;
            tlast_ff     <= s_tlast;
        end
    end

    assign s_tready = tvalid_ff & ~m_tready ? 0 : 1;
    assign m_tvalid = tvalid_ff;
    assign m_tdata  = tdata_ff;
    assign m_tid    = tid_ff;
    assign m_tlast  = tlast_ff;

endmodule