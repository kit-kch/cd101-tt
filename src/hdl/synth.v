/*
 * https://synthesizer-cookbook.com/SynCookbook.pdf
 */

module synth(
    // 20480000 Hz
    input clk,
    input rstn,
    input trig,
    // Configuration
    input[7:0] adsr_ai, adsr_di, adsr_s, adsr_ri,
    input[11:0] osc_count,
    input[7:0] filter_a, filter_b,
    output data
);

    wire clk_mod, clk_sample, clk_adsr, clk_mult;
    clkdiv clki (
        .clk(clk),
        .rstn(rstn_fst_edge),
        .clk_mod(clk_mod), // 20480000 Hz
        .clk_sample(clk_sample), // 20480000/512=40000Hz
        .clk_adsr(clk_adsr), // 40000/512=78.125Hz
        .clk_mult(clk_mult)
    );

    // Synchronize the trigger and resets to the clk_adsr clock, the slowest one
    // Note: This means the signals need to be held for that long!
    reg trig_reg1, trig_reg2;
    reg rstn_reg1, rstn_reg2;
    always @(posedge clk_adsr) begin
        trig_reg1 <= trig;
        rstn_reg1 <= rstn;
        trig_reg2 <= trig_reg1;
        rstn_reg2 <= rstn_reg1;
    end

    reg rstn_fst_reg1, rstn_fst_reg2;
    // Falling edge
    wire rstn_fst_edge = rstn_fst_reg1 | !rstn_fst_reg2;
    always @(posedge clk) begin
        rstn_fst_reg1 <= rstn;
        rstn_fst_reg2 <= rstn_fst_reg1;
    end

    wire[7:0] envelope;
    adsr adsri (
        .clk(clk_adsr),
        .rstn(rstn_reg2),
        .trig(trig_reg2),
        .ai(adsr_ai),
        .di(adsr_di),
        .s(adsr_s),
        .ri(adsr_ri),
        .envelope(envelope)
    );


    wire[7:0] osc_data;
    oscillator osci (
        .clk(clk_sample),
        .rstn(rstn_reg2),
        .count_max(osc_count),
        .data(osc_data)
    );

    wire[15:0] adsr_data;
    shift_mult8 smul8 (
        .clk(clk),
        .clk_slow(clk_sample),
        .a(osc_data),
        .b(envelope),
        .y(adsr_data)
    );

    // Data needs to be constant for whole cycle when feeding into filter
    reg[15:0] adsr_data_reg;
    always @(posedge clk_sample) begin
        adsr_data_reg <= adsr_data;
    end

    wire[15:0] filt_data;
    filter filt (
        .clk(clk_mult),
        .clk_slow(clk_sample),
        .din(adsr_data_reg),
        .dout(filt_data),
        .a(filter_a),
        .b(filter_b)
    );

    dac daci (
        .clk(clk_mod),
        .rstn(rstn_reg2),
        .din(filt_data),
        .dout(data)
    );

endmodule