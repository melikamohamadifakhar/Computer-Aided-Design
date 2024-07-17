SetActiveLib -work
comp -include "$dsn\src\sMachine.vhd" 
comp -include "$dsn\src\TestBench\binarymultipleof3_TB.vhd" 
asim +access +r TESTBENCH_FOR_binarymultipleof3 
wave 
wave -noreg clk
wave -noreg rst
wave -noreg binary_in
wave -noreg is_multiple_of_3
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\binarymultipleof3_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_binarymultipleof3 
