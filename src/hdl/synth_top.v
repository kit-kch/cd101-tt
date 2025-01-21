
module synth_top(
    // 20480000 Hz
    input clk,
    input rst,
    input trig,
    output data,
    // SPI
    input spi_clk,
    input spi_mosi,
    input spi_nss
);

    wire[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri;
    wire[31:0] osc_count;
    wire[15:0] filter_a, filter_b;
    wire spi_rst, spi_trig;

    synth syn (
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .adsr_ai(adsr_ai),
        .adsr_di(adsr_di),
        .adsr_s(adsr_s),
        .adsr_ri(adsr_ri),
        .osc_count(osc_count),
        .filter_a(filter_a),
        .filter_b(filter_b),
        .data(data)
    );

    spi uut (
        .clk(spi_clk),
        .mosi(spi_mosi),
        .nss(spi_nss),

        .adsr_ai(adsr_ai), .adsr_di(adsr_di), .adsr_s(adsr_s), .adsr_ri(adsr_ri),
        .osc_count(osc_count),
        .filter_a(filter_a), .filter_b(filter_b),
        .mute(spi_rst),
        .trig(spi_trig)
    );

endmodule