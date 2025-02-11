/*
 * https://blog.landr.com/adsr-envelopes-infographic/
 * https://de.wikipedia.org/wiki/ADSR
 */

module adsr(
    input clk,
    input rstn,
    input trig,
    input[7:0] ai, di, s, ri,
    output reg[7:0] envelope
);
    reg[2:0] state;

    localparam STATE_IDLE = 3'd0;
    localparam STATE_A = 3'd1;
    localparam STATE_D = 3'd2;
    localparam STATE_S = 3'd3;
    localparam STATE_R = 3'd4;

    wire[8:0] next_sum;
    reg[8:0] sum_op;
    assign next_sum = {1'b0, envelope} + sum_op;

    always @(*) begin
        case (state)
            STATE_A: sum_op = {1'b0, ai};
            STATE_D: sum_op = {1'b1, di};
            STATE_R: sum_op = {1'b1, ri};
            default: sum_op = 0;
        endcase
    end

    always @(posedge clk) begin
        if (rstn == 1'b0) begin
            state <= STATE_IDLE;
            envelope <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    envelope <= next_sum[7:0];
                    if (trig == 1'b1) begin
                        state <= STATE_A;
                    end
                end
                STATE_A: begin
                    envelope <= next_sum[7:0];
                    if (trig == 1'b0) begin
                        state <= STATE_R;
                    end else begin
                        if (next_sum[8] == 1'b1) begin
                            envelope <= 8'hFF;
                            state <= STATE_D;
                        end
                    end
                end
                STATE_D: begin
                    envelope <= next_sum[7:0];
                    if (trig == 1'b0) begin
                        state <= STATE_R;
                    end else begin
                        if (next_sum[7:0] == s) begin
                            state <= STATE_S;
                        end
                    end
                end
                STATE_S: begin
                    envelope <= next_sum[7:0];
                    if (trig == 1'b0) begin
                        state <= STATE_R;
                    end
                end
                STATE_R: begin
                    envelope <= next_sum[7:0];
                    if (next_sum[8] == 1'b1) begin
                        envelope <= 8'h00;
                        state <= STATE_IDLE;
                    end
                end
                default: begin
                end
            endcase
        end
    end
endmodule