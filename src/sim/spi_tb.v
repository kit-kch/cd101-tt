`timescale 1ns/1ps

module spi_tb();

    reg clk, nss, mosi, arstn;

    initial begin
        $dumpfile("build/sim/spi_tb.vcd");
        $dumpvars();

        clk = 0;
        #5000 $finish;
    end
    always #5 clk = ~clk;

    reg [60:0] data_in;
    integer i;
    initial begin
        data_in = (60'hEFCD9AB78563412 << 1) | 61'b1;

        arstn = 0;
        nss = 1'b1;
        #50 arstn = 1;
        #50 nss = 1'b0;
        #5;
        for (i = 0; i < 61; i = i + 1) begin
            #10 data_in = data_in >> 1;
        end
        nss = 1'b1;
    end
    assign mosi = data_in[0];
    


    wire[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri;
    wire[11:0] osc_count;
    wire[7:0] filter_a, filter_b;
    wire progn;
    wire trig;
    spi uut (
        .clk(clk),
        .arstn(arstn),
        .mosi(mosi),
        .nss(nss),

        .adsr_ai(adsr_ai), .adsr_di(adsr_di), .adsr_s(adsr_s), .adsr_ri(adsr_ri),
        .osc_count(osc_count),
        .filter_a(filter_a), .filter_b(filter_b),
        .progn(progn),
        .trig(trig)
    );

endmodule