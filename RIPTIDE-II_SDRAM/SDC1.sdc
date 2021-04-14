create_clock -period 20.0 [get_ports clk]
derive_pll_clocks
derive_clock_uncertainty
set_input_delay -clock PLL_inst|altpll_component|auto_generated|pll1|clk[0] -max 0.2 [all_inputs]
set_input_delay -clock PLL_inst|altpll_component|auto_generated|pll1|clk[0] -min 0.1 [all_inputs]
set_output_delay -clock PLL_inst|altpll_component|auto_generated|pll1|clk[0] -max 0.2 [all_outputs]
set_output_delay -clock PLL_inst|altpll_component|auto_generated|pll1|clk[0] -min 0.1 [all_outputs]
