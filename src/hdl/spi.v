
module spi (
    input clk,
    input mosi,
    input nss,

    output[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri,
    output[31:0] osc_count,
    output[15:0] filter_a, filter_b,
    output mute,
    output trig
);

    // Mute during programming
    assign mute = ~nss;
    // FIXME: Should support trigger using SPI, but this should not mute...
    assign trig = 1'b0;
    
    reg[95:0] cfg;
    always @(posedge clk) begin
        if (nss == 1'b0) begin
            cfg <= {cfg[94:0], mosi};
        end
    end

    assign adsr_ai[7:0] = cfg[7:0];
    assign adsr_di[7:0] = cfg[15:8];
    assign adsr_s[7:0] = cfg[23:16];
    assign adsr_ri[7:0] = cfg[31:24];

    assign osc_count[31:0] = cfg[63:32];
    assign filter_a[15:0] = cfg[79:64];
    assign filter_b[15:0] = cfg[95:80];

endmodule