/*
 * Based on: https://www.fpga4fun.com/PWM_DAC_2.html
 *           https://www.fpga4fun.com/PWM_DAC_3.html 
 * See also: https://dsp.stackexchange.com/questions/69004/how-does-the-worlds-simplest-sigma-delta-dac-work
 *           https://www.edaboard.com/threads/resolution-of-a-sigma-delta-modulator.280812/
 *           https://www.beis.de/Elektronik/DeltaSigma/DeltaSigma_D.html
 * 1024x Oversampling is then ~14 ENOB
 */

module dac (
    input clk,
    input[15:0] din,
    output dout
);

    reg[16:0] accumulator;
    always @(posedge clk) begin
        accumulator <= accumulator[15:0] + din;
    end
    assign dout = accumulator[16];

endmodule