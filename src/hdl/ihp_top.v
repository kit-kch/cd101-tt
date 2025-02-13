module tt_um_kch_cd101 (
    input  wire p_spi_nss,    // Dedicated inputs
    input  wire p_spi_mosi,    // Dedicated inputs
    input  wire p_spi_clk,    // Dedicated inputs
    input  wire p_trig,    // Dedicated inputs
    output wire p_data,  // IOs: Output path
    input  wire p_clk,      // clock
    input  wire p_rst_n     // reset_n - low to reset
);

    wire trig, data, spi_clk, spi_mosi, spi_nss, clk, rst_n;

    // All output pins must be assigned. If not used, assign to 0.

    synth_top stop (
        .clk(clk),
        .rstn(rst_n),
        .trig(trig),
        .data(data),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_nss(spi_nss)
    );


  (* keep *) sg13g2_IOPadIn u_pad_io_spi_nss (.pad(p_spi_nss), .p2c(spi_nss)) ;
  (* keep *) sg13g2_IOPadIn u_pad_io_spi_mosi (.pad(p_spi_mosi), .p2c(spi_mosi)) ;
  (* keep *) sg13g2_IOPadIn u_pad_io_spi_clk (.pad(p_spi_clk), .p2c(spi_clk)) ;
  (* keep *) sg13g2_IOPadIn u_pad_io_trig (.pad(p_trig), .p2c(trig)) ;
  (* keep *) sg13g2_IOPadIn u_pad_io_clk (.pad(p_clk), .p2c(clk)) ;
  (* keep *) sg13g2_IOPadIn u_pad_io_rst_n (.pad(p_rst_n), .p2c(rst_n)) ;

  (* keep *) sg13g2_IOPadOut4mA u_pad_io_data (.pad(p_data), .c2p(data)) ;

  (* keep *) sg13g2_IOPadIOVdd u_pad_vddpad_0 () ;
  (* keep *) sg13g2_IOPadIOVdd u_pad_vddpad_1 () ;

  (* keep *) sg13g2_IOPadVdd u_pad_vddcore_0 () ;
  (* keep *) sg13g2_IOPadVdd u_pad_vddcore_1 () ;

  (* keep *) sg13g2_IOPadIOVss u_pad_gndpad_0 () ;
  (* keep *) sg13g2_IOPadIOVss u_pad_gndpad_1 () ;

  (* keep *) sg13g2_IOPadVss u_pad_gndcore_0 () ;
  (* keep *) sg13g2_IOPadVss u_pad_gndcore_1 () ;

endmodule
