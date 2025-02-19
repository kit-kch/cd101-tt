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
    input rstn,
    input clk_sample,
    input mult_rst,
    input[15:0] din,
    output[15:0] dout,
    input[7:0] a,
    input[7:0] b
);
    wire[15:0] m1o;
    wire[15:0] m2o;

    reg[15:0] dout_reg;
    always @(posedge clk_sample or negedge rstn) begin
        if (rstn == 1'b0)
            dout_reg <= 0;
        else
            dout_reg <= m1o + m2o;
    end
    assign dout = dout_reg;

    shift_mult16 m1(
        .clk(clk),
        .mult_rst(mult_rst),
        .a(dout_reg),
        .b(a),
        .y(m1o)
    );

    shift_mult16 m2(
        .clk(clk),
        .mult_rst(mult_rst),
        .a(din),
        .b(b),
        .y(m2o)
    );

endmodule