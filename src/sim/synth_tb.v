`timescale 1ns/1ps

module synth_tb();

    localparam ADSR_AI = 5;
    localparam ADSR_DI = 10;
    localparam ADSR_S = 64;
    localparam ADSR_RI = 1;
    localparam PULSE_PERIOD_2 = 2;

    wire[15:0] data;
    reg clk;
    reg rst, trig;

    initial begin
        $dumpfile("out/sim/synth_tb.vcd");
        $dumpvars();

        clk = 0;
        #10000 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        trig = 1'b0;
        #50 rst = 1'b0;
        #50 trig = 1'b1;
        #4000 trig = 1'b0;
    end

    synth uut (
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .ai(ADSR_AI),
        .di(ADSR_DI),
        .s(ADSR_S),
        .ri(ADSR_RI),
        .count_max(PULSE_PERIOD_2),
        .data(data)
    );

endmodule