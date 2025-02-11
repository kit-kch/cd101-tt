module shift_mult8 (
    input clk,
    // We want to sample this sync and async
    // verilator lint_off SYNCASYNCNET
    input mult_rst,
    // verilator lint_on SYNCASYNCNET
    input[7:0] a,
    input[7:0] b,
    output[15:0] y
);

    // Latch register for B
    reg[7:0] b_latched;
    always @(negedge clk) begin
        if (mult_rst == 1'b1)
            b_latched <= b;
        else
            b_latched <= {1'b0, b_latched[7:1]};
    end

    wire b_bit = b_latched[0];
    wire[7:0] sum_in1 = a & {8{b_bit}};

    // Adder
    reg[15:0] y_buf;
    // Second op: Shifted
    wire[7:0] sum_in2 = {y_buf[15:8]};
    
    always @(negedge clk or posedge mult_rst) begin
        if (mult_rst == 1'b1) begin
            y_buf <= 0;
        end else begin
            y_buf[15:7] <= sum_in1 + sum_in2;
            y_buf[6:0] <= y_buf[7:1];
        end
    end

    assign y = y_buf[15:0];

endmodule