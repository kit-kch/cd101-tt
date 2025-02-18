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
`ifdef USE_CFG_LATCH
    input latch_cfg,
`endif
    output data
);

`ifdef USE_CFG_LATCH
    reg[7:0] adsr_ai_l, adsr_di_l, adsr_s_l, adsr_ri_l;
    reg[11:0] osc_count_l;
    reg[7:0] filter_a_l, filter_b_l;

    always @(posedge clk_adsr) begin
        if (latch_cfg == 1'b1) begin
	    adsr_ai_l <= adsr_ai;
	    adsr_di_l <= adsr_di;
	    adsr_s_l <= adsr_s;
	    adsr_ri_l <= adsr_ri;
	    osc_count_l <= osc_count;
	    filter_a_l <= filter_a;
	    filter_b_l <= filter_b;
        end
    end
`else
    wire[7:0] adsr_ai_l = adsr_ai;
    wire[7:0] adsr_di_l = adsr_di;
    wire[7:0] adsr_s_l = adsr_s;
    wire[7:0] adsr_ri_l = adsr_ri;
    wire[11:0] osc_count_l = osc_count;
    wire[7:0] filter_a_l = filter_a;
    wire[7:0] filter_b_l = filter_b;
`endif

    wire clk_mod, clk_sample, clk_sample_x2, clk_adsr, clk_mult;
    clkdiv clki (
        .clk(clk),
        .arstn(rstn_fst_edge),
        .clk_mod(clk_mod), // 20480000 Hz
        .clk_sample(clk_sample), // 20480000/512=40000Hz
        .clk_sample_x2(clk_sample_x2),
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
    // Falling edge: Only reset the clock gen for a short time
    // Clocks need to be running again for the sync resets to work
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
        .ai(adsr_ai_l),
        .di(adsr_di_l),
        .s(adsr_s_l),
        .ri(adsr_ri_l),
        .envelope(envelope)
    );

    wire[7:0] osc_data;
    oscillator osci (
        .clk(clk_sample),
        .rstn(rstn_reg2),
        .count_max(osc_count_l),
        .data(osc_data)
    );

    // Periodic reset for multipliers. Quite a hack, see docs for details
    wire mult_rst = clk_sample & ~clk_sample_x2;
    wire[15:0] adsr_data;
    shift_mult8 smul8 (
        .clk(clk_mult),
        .mult_rst(mult_rst),
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
        .rstn(rstn_reg2),
        .clk_sample(clk_sample),
        .mult_rst(mult_rst),
        .din(adsr_data_reg),
        .dout(filt_data),
        .a(filter_a_l),
        .b(filter_b_l)
    );

    dac daci (
        .clk(clk_mod),
        .rstn(rstn_reg2),
        .din(filt_data),
        .dout(data)
    );

endmodule