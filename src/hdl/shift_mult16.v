module shift_mult16 #(
    parameter B_WIDTH=8)(
    input clk,
    input mult_rst,
    input[15:0] a,
    input[B_WIDTH-1:0] b,
    output[15:0] y
);

    // Latch register for B
    reg[B_WIDTH-1:0] b_latched;
    always @(negedge clk) begin
        if (mult_rst == 1'b1)
            b_latched <= b;
        else
            b_latched <= {1'b0, b_latched[B_WIDTH-1:1]};
    end

    wire b_bit = b_latched[0];
    wire[15:0] sum_in1 = a & {16{b_bit}};

    // Adder
    reg[15:0] y_buf;
    // Second op: Shifted
    wire[15:0] sum_in2 = {y_buf[15:0]};

    // verilator lint_off UNUSEDSIGNAL
    wire[16:0] sum;
    // verilator lint_on UNUSEDSIGNAL
    assign sum = sum_in1 + sum_in2;
    
    always @(negedge clk or posedge mult_rst) begin
        if (mult_rst == 1'b1)
            y_buf <= 0;
        else
            y_buf <= sum[16:1];
    end

    assign y = y_buf[15:0];

endmodule