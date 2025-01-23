`timescale 1ns/1ps

module adsr_tb();

    localparam ADSR_AI = 5;
    localparam ADSR_DI = -10;
    localparam ADSR_S = 65;
    localparam ADSR_RI = -1;

    wire[7:0] envelope;
    reg clk;
    reg rstn, trig;

    initial begin
        $dumpfile("build/sim/adsr_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        rstn = 1'b0;
        trig = 1'b0;
        #50 rstn = 1'b1;
        #50 trig = 1'b1;
        #4000 trig = 1'b0;
        #800 trig = 1'b1;
        #500 trig = 1'b0;
    end

    adsr uut (
        .clk(clk),
        .rstn(rstn),
        .trig(trig),
        .ai(ADSR_AI),
        .di(ADSR_DI),
        .s(ADSR_S),
        .ri(ADSR_RI),
        .envelope(envelope)
    );

endmodule