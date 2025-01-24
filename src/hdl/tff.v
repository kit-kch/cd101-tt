/*
 * Simple Toggle FF
 */

module tff(
    input clk,
    input arstn,
    output reg q
);

    always @(posedge clk or negedge arstn) begin
        if (arstn == 1'b0)
            q <= 1'b0;
        else
            q <= ~q;
    end

endmodule