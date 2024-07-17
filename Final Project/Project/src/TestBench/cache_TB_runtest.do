SetActiveLib -work
comp -include "$dsn\src\cache.vhd" 
comp -include "$dsn\src\TestBench\cache_TB.vhd" 
asim +access +r TESTBENCH_FOR_cache 
wave 
wave -noreg clk
wave -noreg input
wave -noreg hit
wave -noreg data
wave -noreg write_enable
wave -noreg write_data
wave -noreg wb_addr
wave -noreg wb_data
wave -noreg wb_enable
wave -noreg wb_ack
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\cache_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_cache 
