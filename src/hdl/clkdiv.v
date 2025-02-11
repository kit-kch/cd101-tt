/*
 * Async clock divider
 * https://digilent.com/reference/learn/programmable-logic/tutorials/use-flip-flops-to-build-a-clock-divider/start
 */

module clkdiv(
    input clk,
    input arstn,
    output clk_mod,
    output clk_sample,
    output clk_sample_x2,
    output clk_adsr,
    output clk_mult
);
    wire[16:0] q;

    assign q[0] = clk;

    assign clk_mod = q[0];
    assign clk_sample = q[9];
    assign clk_sample_x2 = q[8];
    assign clk_adsr = q[16];
    assign clk_mult = q[5];

    genvar i;
    generate for (i = 0; i < 16; i = i+1) 
        begin: gen
            tff inst (
                .clk(q[i]),
                .arstn(arstn),
                .q(q[i+1])
            );
        end
    endgenerate;

endmodule