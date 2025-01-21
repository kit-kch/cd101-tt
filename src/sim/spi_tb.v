`timescale 1ns/1ps

module spi_tb();

    reg clk, nss, mosi;

    initial begin
        $dumpfile("build/sim/spi_tb.vcd");
        $dumpvars();

        clk = 0;
        #5000 $finish;
    end
    always #5 clk = ~clk;

    reg [95:0] data_in;
    integer i;
    initial begin
        data_in = 96'h123456789ABCDEF012345678;

        nss = 1'b1;
        #50 nss = 1'b0;
        #5;
        for (i = 0; i < 96; i = i + 1) begin
            #10 data_in = data_in << 1;
        end
        nss = 1'b1;
    end
    assign mosi = data_in[95];


    wire[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri;
    wire[31:0] osc_count;
    wire[15:0] filter_a, filter_b;
    wire mute;
    wire trig;
    spi uut (
        .clk(clk),
        .mosi(mosi),
        .nss(nss),

        .adsr_ai(adsr_ai), .adsr_di(adsr_di), .adsr_s(adsr_s), .adsr_ri(adsr_ri),
        .osc_count(osc_count),
        .filter_a(filter_a), .filter_b(filter_b),
        .mute(mute),
        .trig(trig)
    );

endmodule