/*
 * https://synthesizer-cookbook.com/SynCookbook.pdf
 */
`timescale 1ns/1ps

module synth(
    input clk,
    input rst,
    input trig,
    // Configuration
    input[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri,
    input[31:0] osc_count,
    input[15:0] filter_a, filter_b,
    output data
);

    wire[7:0] envelope;
    adsr adsri (
        .clk(clk),
        .ce(1),
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
        .clk(clk),
        .count_max(osc_count),
        .data(osc_data)
    );

    wire[15:0] adsr_data;
    assign adsr_data = osc_data * envelope;

    wire[15:0] filt_data;
    filter filt (
        .clk(clk),
        .din(adsr_data),
        .dout(filt_data),
        .a(filter_a),
        .b(filter_b)
    );

    dac daci (
        .clk(clk),
        .din(filt_data),
        .dout(data)
    );

endmodule