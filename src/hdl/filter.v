/*
 * Single pole IIR filter aka EWMA filter:
 * https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average
 * https://tomroelandts.com/articles/low-pass-single-pole-iir-filter
 * https://fiiir.com/
 * https://dsp.stackexchange.com/questions/54086/single-pole-iir-low-pass-filter-which-is-the-correct-formula-for-the-decay-coe
 * https://dsp.stackexchange.com/questions/28308/exponential-weighted-moving-average-time-constant/28314#28314
 * "Digital Filters For Music Synthesis": One Pole Filter, section 3.1.1, p5
 */

// y[n]=y[n−1]+b(x[n]−y[n−1]).
// y[n]=ay[n−1]+bx[n]

module filter(
    input clk,
    input clk_slow,
    input[15:0] din,
    output[15:0] dout,
    input[7:0] a,
    input[7:0] b
);
    wire[15:0] m1o;
    wire[15:0] m2o;

    shift_mult16 m1(
        .clk(clk),
        .clk_slow(clk_slow),
        .a(dout),
        .b(a),
        .y(m1o)
    );

    shift_mult16 m2(
        .clk(clk),
        .clk_slow(clk_slow),
        .a(din),
        .b(a),
        .y(m2o)
    );

    assign dout = m1o + m2o;

endmodule