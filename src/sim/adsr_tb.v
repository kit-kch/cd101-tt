`timescale 1ns/1ps

module adsr_tb();

    localparam ADSR_AI = 5;
    localparam ADSR_DI = 10;
    localparam ADSR_S = 64;
    localparam ADSR_RI = 1;

    wire[7:0] envelope;
    reg clk;
    reg rst, trig;

    initial begin
        $dumpfile("out/sim/adsr_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    reg[1:0] counter;
    wire ce;
    assign ce = counter == 2'b11;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    initial begin
        rst = 1'b1;
        trig = 1'b0;
        #50 rst = 1'b0;
        #50 trig = 1'b1;
        #4000 trig = 1'b0;
    end

    adsr uut (
        .clk(clk),
        .ce(ce),
        .rst(rst),
        .trig(trig),
        .ai(ADSR_AI),
        .di(ADSR_DI),
        .s(ADSR_S),
        .ri(ADSR_RI),
        .envelope(envelope)
    );

endmodule