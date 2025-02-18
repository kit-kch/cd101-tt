
module spi (
    input clk,
    input arstn,
    input mosi,
    // We want to sample this sync and async
    // verilator lint_off SYNCASYNCNET
    input nss,
    // verilator lint_on SYNCASYNCNET

    output[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri,
    output[11:0] osc_count,
    output[7:0] filter_a, filter_b,
    output progn,
    output reg trig
);

    // Mute during programming. Note: This is sampled using the adsr clock,
    // So to make sure there really is a reset, nss needs to be held for
    // (1/main clk) * (512 * 128) (~3.125ms)
    assign progn = first_bit_reg | nss;
    
    reg first_bit;
    reg first_bit_reg;
    always @(posedge clk or posedge nss) begin
        if (nss == 1'b1) begin
            first_bit <= 1;
            first_bit_reg <= 1;
        end else begin
            first_bit <= 0;
            first_bit_reg <= first_bit;
        end
    end

    reg[59:0] cfg;
    always @(posedge clk or negedge arstn) begin
        if (arstn == 1'b0) begin
            cfg <= 0;
        end else if (nss == 1'b0 && first_bit == 1'b0) begin
            cfg <= {mosi, cfg[59:1]};
        end
    end

    always @(posedge clk or negedge arstn) begin
        if (arstn == 1'b0) begin
            trig <= 0;
        end else if (nss == 1'b0 && first_bit == 1'b1) begin
            trig <= mosi;
        end
    end

    assign adsr_ai[7:0] = cfg[7:0];
    assign adsr_di[7:0] = cfg[15:8];
    assign adsr_s[7:0] = cfg[23:16];
    assign adsr_ri[7:0] = cfg[31:24];

    assign osc_count[11:0] = cfg[43:32];
    assign filter_a[7:0] = cfg[51:44];
    assign filter_b[7:0] = cfg[59:52];

endmodule