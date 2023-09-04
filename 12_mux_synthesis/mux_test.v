module mux_test;

  wire mux_out;
  reg  clock;
  reg  [1:0] select;
  reg  in1, in2, in3;

  mux mux_i (mux_out, clock, select, in1, in2, in3) ;

  task expect (input expected_mux_out);
    if (mux_out !== expected_mux_out) begin
        $display("TEST FAILED");
        $display("time=%0d select=%b in1=%b in2=%b in3=%b mux_out=%b",
                 $time, select, in1, in2, in3, mux_out);
        $display("mux_out should be %b", expected_mux_out);
        $finish;
      end
    else begin
        $display("time=%0d select=%b in1=%b in2=%b in3=%b mux_out=%b",
                 $time, select, in1, in2, in3, mux_out);
    end
  endtask

  initial repeat (9) begin clock=1; #5; clock=0; #5; end

  initial @(negedge clock) begin
   {select, in1, in2, in3} = 5'b00_0xx; @(negedge clock) expect (0) ; // 0 in1
   {select, in1, in2, in3} = 5'b00_1xx; @(negedge clock) expect (1) ; // 0 in1
   {select, in1, in2, in3} = 5'b01_1xx; @(negedge clock) expect (1) ; // 1 in1
   {select, in1, in2, in3} = 5'b01_0xx; @(negedge clock) expect (0) ; // 1 in1
   {select, in1, in2, in3} = 5'b10_x0x; @(negedge clock) expect (0) ; // 2 in2
   {select, in1, in2, in3} = 5'b10_x1x; @(negedge clock) expect (1) ; // 2 in2
   {select, in1, in2, in3} = 5'b11_xx1; @(negedge clock) expect (1) ; // 3 in3
   {select, in1, in2, in3} = 5'b11_xx0; @(negedge clock) expect (0) ; // 3 in3
   $display("TEST PASSED");
   $finish;
  end

endmodule
