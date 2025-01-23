
module synth_top(
    // 20480000 Hz
    input clk,
    input rstn,
    input trig,
    output data,
    // SPI
    input spi_clk,
    input spi_mosi,
    input spi_nss
);

    wire[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri;
    wire[11:0] osc_count;
    wire[7:0] filter_a, filter_b;
    wire spi_rst, spi_trig;

    synth syn (
        .clk(clk),
        .rstn(rstn),
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

    spi ctrl (
        .clk(spi_clk),
        .arstn(rstn),
        .mosi(spi_mosi),
        .nss(spi_nss),

        .adsr_ai(adsr_ai), .adsr_di(adsr_di), .adsr_s(adsr_s), .adsr_ri(adsr_ri),
        .osc_count(osc_count),
        .filter_a(filter_a), .filter_b(filter_b),
        .mute(spi_rst),
        .trig(spi_trig)
    );

endmodule