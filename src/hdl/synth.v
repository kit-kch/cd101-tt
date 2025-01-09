/*
 * https://synthesizer-cookbook.com/SynCookbook.pdf
 */
`timescale 1ns/1ps

module synth(
    input clk,
    input rst,
    input trig,
    input[7:0] ai, di, s , ri,
    input[31:0] count_max,
    output[15:0] data
);
    wire[7:0] envelope;
    wire[7:0] oscdata;

    adsr adsri (
        .clk(clk),
        .ce(1),
        .rst(rst),
        .trig(trig),
        .ai(ai),
        .di(di),
        .s(s),
        .ri(ri),
        .envelope(envelope)
    );

    oscillator osci (
        .clk(clk),
        .count_max(count_max),
        .data(oscdata)
    );

    assign data = oscdata * envelope;

endmodule