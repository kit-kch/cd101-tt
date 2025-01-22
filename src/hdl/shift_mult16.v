module shift_mult16(
    input clk,
    input clk_slow,
    input[15:0] a,
    input[15:0] b,
    output[15:0] y
);

    // Latch register for B
    reg[15:0] b_latched;
    always @(posedge clk or posedge clk_slow) begin
        if (clk_slow == 1'b1)
            b_latched <= b;
        else
            b_latched <= {1'b0, b_latched[15:1]};
    end

    wire b_bit = b_latched[0];
    wire[15:0] sum_in1 = a & {16{b_bit}};

    // Adder
    reg[16:0] y_buf;
    // Second op: Shifted
    wire[15:0] sum_in2 = {y_buf[16:1]};
    
    always @(posedge clk or posedge clk_slow) begin
        if (clk_slow == 1'b1)
            y_buf <= 0;
        else
            y_buf <= sum_in1 + sum_in2;
    end

    assign y = y_buf[16:1];

endmodule