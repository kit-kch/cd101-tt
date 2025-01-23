/*
 * Async clock divider
 * https://digilent.com/reference/learn/programmable-logic/tutorials/use-flip-flops-to-build-a-clock-divider/start
 */

module clkdiv(
    input clk,
    input arst,
    output clk_mod,
    output clk_sample,
    output clk_adsr,
    output clk_mult
);
    wire[18:0] q;
    wire[18:0] qn;

    assign q[0] = clk;

    assign clk_mod = q[0];
    assign clk_sample = q[9];
    assign clk_adsr = q[18];
    assign clk_mult = q[5];

    genvar i;
    generate for (i = 0; i < 18; i = i+1) 
        begin: gen
            dff inst (
                .clk(q[i]),
                .arst(arst),
                .d(qn[i+1]),
                .q(q[i+1]),
                .qn(qn[i+1])
            );
        end
    endgenerate;

endmodule