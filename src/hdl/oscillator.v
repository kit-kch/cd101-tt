/*
 * Pulse waveform generator
 */

module oscillator(
    input clk,
    input[31:0] count_max,
    output reg[7:0] data
);

    reg[31:0] counter;
    reg data_buf;

    initial data_buf = 1;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= count_max) begin
            counter <= 0;
            data_buf <= ! data_buf;
        end
    end


    always @(data_buf) begin
        if (data_buf == 0) begin
            data = 0;
        end else begin
            data = 8'hFF;
        end
    end

endmodule