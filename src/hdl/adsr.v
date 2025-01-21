/*
 * https://blog.landr.com/adsr-envelopes-infographic/
 * https://de.wikipedia.org/wiki/ADSR
 */
`timescale 1ns/1ps

module adsr(
    input clk,
    input rst,
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

    reg[8:0] next_sum;
    always @(state, envelope) begin
        if (state == STATE_A) begin
            next_sum = envelope + ai;
        end else begin
            // TODO: Can I write this as +?
            next_sum = envelope - ri;
        end
    end

    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
            envelope <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (trig == 1'b1) begin
                        state <= STATE_A;
                    end
                end
                STATE_A: begin
                    if (trig == 1'b0) begin
                        state <= STATE_R;
                    end else begin
                        if (next_sum[8] == 1'b1) begin
                            envelope <= 8'hFF;
                            state <= STATE_D;
                        end else begin
                            envelope <= next_sum[7:0];
                        end;
                    end;
                end
                STATE_D: begin
                    if (trig == 1'b0) begin
                        state <= STATE_R;
                    end else begin
                        // Underflow
                        if ((envelope - di) > envelope) begin
                            state <= STATE_S;
                            envelope <= 8'h00;
                        end else if ((envelope - di) < s) begin
                            state <= STATE_S;
                            envelope <= s;
                        end else begin
                            envelope <= envelope - di;
                        end
                    end;
                end
                STATE_S: begin
                    if (trig == 1'b0) begin
                        state <= STATE_R;
                    end
                end
                STATE_R: begin
                    if (next_sum[8] == 1'b1) begin
                        envelope <= 8'h00;
                        state <= STATE_IDLE;
                    end else begin
                        envelope <= next_sum[7:0];
                    end;
                end
                default: begin
                end
            endcase
        end
    end
endmodule