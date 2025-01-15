/*
 * Simple D FF
 */
`timescale 1ns/1ps

module dff(
    input clk,
    input arst,
    input d,
    output reg q,
    output qn
);

    always @(posedge clk or posedge arst) begin
        if (arst == 1'b1) begin
            q <= 1'b1;
        end else begin
            q <= d;
        end
    end
    assign qn = ~q;

endmodule