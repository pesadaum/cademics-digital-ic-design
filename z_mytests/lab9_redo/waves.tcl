database -open waves -into waves.shm -default
probe -create -shm tb_xor.clk tb_xor.A tb_xor.B tb_xor.Q -waveform
reset
run
