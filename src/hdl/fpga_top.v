module fpga_top(
    input rst,
    input trig,
    output data,
    output dbg_clk,
    output dbg_rst,
    // SPI
    input spi_clk,
    input spi_mosi,
    input spi_nss
);
    wire clk_48;
    wire clk;
    wire pll_locked;

    // Internal RC Oscillator at 48 MHz
    SB_HFOSC rcosc (
        .CLKHFPU(1'b1),
        .CLKHFEN(1'b1),
        .CLKHF(clk_48),
        .TRIM0(),
        .TRIM1(),
        .TRIM2(),
        .TRIM3(),
        .TRIM4(),
        .TRIM5(),
        .TRIM6(),
        .TRIM7(),
        .TRIM8(),
        .TRIM9()
    );

    fpga_pll pll (
        .clock_in(clk_48),
        .clock_out(clk),
        .locked(pll_locked)
    );

    // Debug clock
    reg[24:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end
    assign dbg_clk = counter[24];
    wire rstn = ~rst;
    // LED is low active
    assign dbg_rst = rstn;

    synth_top stop (
        .clk(clk),
        .rstn(rstn),
        .trig(trig),
        .data(data),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_nss(spi_nss)
    );

endmodule