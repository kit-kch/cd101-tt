ctx.addClock("pll.clock_in", 48)
ctx.addClock("pll.clock_out", 20.5)
ctx.addClock("stop.syn.clki.q[0]", 20.5)
ctx.addClock("stop.syn.clki.q[9]", 0.04)
ctx.addClock("stop.syn.clki.q[18]", 20.5 / (512 * 512))