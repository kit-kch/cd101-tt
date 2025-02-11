/*
 * Pulse waveform generator
 */

module oscillator(
    input clk,
    input rstn,
    input[11:0] count_max,
    output reg[7:0] data
);

    reg[11:0] counter;
    reg data_buf;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (rstn == 0) begin
            counter <= 0;
            data_buf <= 0;
        end
        if (counter == count_max) begin
            counter <= 0;
            data_buf <= !data_buf;
        end
    end


    always @(*) begin
        if (data_buf == 0) begin
            data = 0;
        end else begin
            data = 8'hFF;
        end
    end

endmodule