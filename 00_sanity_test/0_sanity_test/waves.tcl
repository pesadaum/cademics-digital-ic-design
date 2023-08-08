database -open waves -into waves.shm -default
probe -create -shm register_test.clk register_test.data_in register_test.data_out register_test.rst -waveform
reset
run
