
module spi (
    input clk,
    input rstn,
    input mosi,
    input nss,

    output[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri,
    output[11:0] osc_count,
    output[7:0] filter_a, filter_b,
    output mute,
    output trig
);

    // Mute during programming
    assign mute = ~nss;
    // FIXME: Should support trigger using SPI, but this should not mute...
    assign trig = 1'b0;
    
    reg[59:0] cfg;
    always @(posedge clk) begin
        if (nss == 1'b0) begin
            cfg <= {cfg[58:0], mosi};
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