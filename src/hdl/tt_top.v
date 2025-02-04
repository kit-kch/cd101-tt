/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire trig, data;
    wire spi_clk, spi_mosi, spi_nss;
    assign trig = ui_in[0];
    assign spi_clk = ui_in[1];
    assign spi_mosi = ui_in[2];
    assign spi_nss = ui_in[3];
    assign uo_out[7] = data;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[7:4], uio_in[7:0], 1'b0};

    // All output pins must be assigned. If not used, assign to 0.
    assign uio_out = 0;
    assign uio_oe = 0;
    assign uo_out[6:0] = 0;

    synth_top stop (
        .clk(clk),
        .rstn(rst_n),
        .trig(trig),
        .data(data),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_nss(spi_nss)
    );

endmodule
