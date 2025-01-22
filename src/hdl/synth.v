/*
 * https://synthesizer-cookbook.com/SynCookbook.pdf
 */

module synth(
    // 20480000 Hz
    input clk,
    input rst,
    input trig,
    // Configuration
    input[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri,
    input[31:0] osc_count,
    input[15:0] filter_a, filter_b,
    output data
);

    wire clk_mod, clk_sample, clk_adsr, clk_filt;
    clkdiv clki (
        .clk(clk),
        .arst(rst),
        .clk_mod(clk_mod), // 20480000 Hz
        .clk_sample(clk_sample), // 20480000/512=40000Hz
        .clk_adsr(clk_adsr), // 40000/512=78.125Hz
        .clk_filt(clk_filt)
    );

    wire[7:0] envelope;
    adsr adsri (
        .clk(clk_adsr),
        .rst(rst),
        .trig(trig),
        .ai(adsr_ai),
        .di(adsr_di),
        .s(adsr_s),
        .ri(adsr_ri),
        .envelope(envelope)
    );

    wire[7:0] osc_data;
    oscillator osci (
        .clk(clk_sample),
        .count_max(osc_count),
        .data(osc_data)
    );

    wire[15:0] adsr_data;
    assign adsr_data = osc_data * envelope;

    wire[15:0] filt_data;
    filter filt (
        .clk(clk_filt),
        .clk_slow(clk_sample),
        .din(adsr_data),
        .dout(filt_data),
        .a(filter_a),
        .b(filter_b)
    );

    dac daci (
        .clk(clk_mod),
        .din(filt_data),
        .dout(data)
    );

endmodule