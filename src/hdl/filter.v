/*
 * Single pole IIR filter aka EWMA filter:
 * https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average
 * https://tomroelandts.com/articles/low-pass-single-pole-iir-filter
 * https://fiiir.com/
 * https://dsp.stackexchange.com/questions/54086/single-pole-iir-low-pass-filter-which-is-the-correct-formula-for-the-decay-coe
 * https://dsp.stackexchange.com/questions/28308/exponential-weighted-moving-average-time-constant/28314#28314
 * "Digital Filters For Music Synthesis": One Pole Filter, section 3.1.1, p5
 */

`timescale 1ns/1ps

