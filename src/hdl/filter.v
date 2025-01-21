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
    input[15:0] din,
    output reg[15:0] dout,
    input[15:0] a,
    input[15:0] b
);
    reg[31:0] m1;
    reg[31:0] m2;

    always @(posedge clk) begin
        m1 = a * dout;
        m2 = b * din;
        dout <= m1[31:16] + m2[31:16];
    end

endmodule