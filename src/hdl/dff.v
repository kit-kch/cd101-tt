/*
 * Simple D FF
 */

module dff(
    input clk,
    input rstn,
    input d,
    output reg q,
    output qn
);

    always @(posedge clk) begin
        if (rstn == 1'b0) begin
            q <= 1'b1;
        end else begin
            q <= d;
        end
    end
    assign qn = ~q;

endmodule