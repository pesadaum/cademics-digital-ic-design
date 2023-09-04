////////////////////////////////////////////////////////////////////////////////
// this tests all units if none are specified                                 //
////////////////////////////////////////////////////////////////////////////////
`ifndef priority7
 `ifndef latchrs
  `ifndef dffrs
   `ifndef drive8
    `define priority7
    `define latchrs
    `define dffrs
    `define drive8
   `endif
  `endif
 `endif
`endif

module lib_test;

`ifdef priority7
  wire [2:0] py ;
  reg  [7:1] pa ;
  priority7 priority7_i ( py, pa ) ;
  task p_expect ( input [2:0] xy ) ;
    if (py !== xy) begin
        $display("TEST FAILED - PRIORITY");
        $display("time=%0d input=%b output=%b", $time, pa, py);
        $display("output should be %b", xy);
        $finish;
      end
  endtask
  initial begin
      pa = 7'bxxxxxx1; #1 p_expect ( 1 );
      pa = 7'bxxxxx10; #1 p_expect ( 2 );
      pa = 7'bxxxx100; #1 p_expect ( 3 );
      pa = 7'bxxx1000; #1 p_expect ( 4 );
      pa = 7'bxx10000; #1 p_expect ( 5 );
      pa = 7'bx100000; #1 p_expect ( 6 );
      pa = 7'b1000000; #1 p_expect ( 7 );
      $display("TEST PASSED - PRIORITY");
    end
`endif

`ifdef latchrs
  wire lq ;
  reg  le, ld, lr, ls ;
  latchrs latchrs_i ( lq, le, ld, lr, ls ) ;
  task l_expect ( input xq ) ;
    if (lq !== xq) begin
        $display("TEST FAILED - LATCH");
        $display("time=%0d enable=%b data=%b reset=%b set=%b output=%b",
                  $time, le, ld, lr, ls, lq);
        $display("output should be %b", xq);
        $finish;
      end
  endtask
  initial begin
      {le, ld, lr, ls} = 4'b0000; #1 l_expect ( 1 ) ;
      {le, ld, lr, ls} = 4'b0001; #1 l_expect ( 0 ) ;
      {le, ld, lr, ls} = 4'b0011; #1 l_expect ( 0 ) ;
      {le, ld, lr, ls} = 4'b1111; #1 l_expect ( 1 ) ;
      {le, ld, lr, ls} = 4'b1011; #1 l_expect ( 0 ) ;
      {le, ld, lr, ls} = 4'b0011; #1 l_expect ( 0 ) ;
      {le, ld, lr, ls} = 4'bxx10; #1 l_expect ( 1 ) ;
      {le, ld, lr, ls} = 4'bxx01; #1 l_expect ( 0 ) ;
      $display("TEST PASSED - LATCH");
    end
`endif

`ifdef dffrs
  wire fq ;
  reg  fc, fd, fe, fr, fs ;
  dffrs dffrs_i (fq, fc, fd, fe, fr, fs) ;
  task f_expect ( input xq ) ;
    if (fq !== xq) begin
        $display("TEST FAILED - DFF");
        $display("time=%0d enable=%b data=%b reset=%b set=%b output=%b",
                  $time, fe, fd, fr, fs, fq);
        $display("output should be %b", xq);
        $finish;
      end
  endtask
  initial repeat (9) begin fc = 1; #1; fc = 0; #1; end
  initial @(negedge fc) begin
      {fe, fd, fr, fs} = 4'b0000; @(negedge fc) f_expect ( 1 ) ;
      {fe, fd, fr, fs} = 4'b0001; @(negedge fc) f_expect ( 0 ) ;
      {fe, fd, fr, fs} = 4'b0011; @(negedge fc) f_expect ( 0 ) ;
      {fe, fd, fr, fs} = 4'b1111; @(negedge fc) f_expect ( 1 ) ;
      {fe, fd, fr, fs} = 4'b1011; @(negedge fc) f_expect ( 0 ) ;
      {fe, fd, fr, fs} = 4'b0x11; @(negedge fc) f_expect ( 0 ) ;
      {fe, fd, fr, fs} = 4'bxx10; @(negedge fc) f_expect ( 1 ) ;
      {fe, fd, fr, fs} = 4'bxx01; @(negedge fc) f_expect ( 0 ) ;
      $display("TEST PASSED - DFF");
    end
`endif

`ifdef drive8
  wire [7:0] dy ;
  reg  [7:0] da ;
  reg        de ;
  drive8 drive8_i ( dy, da, de ) ;
  task d_expect ( input [7:0] xy ) ;
    if (dy !== xy) begin
        $display("TEST FAILED - DRIVER");
        $display("time=%0d input=%b enable=%b output=%b", $time, da, de, dy);
        $display("output should be %b", xy);
        $finish;
      end
  endtask
  initial begin
      {de, da} = 9'h0_xx; #1 d_expect (8'hzz) ;
      {de, da} = 9'h1_55; #1 d_expect (8'h55) ;
      {de, da} = 9'h1_AA; #1 d_expect (8'hAA) ;
      $display("TEST PASSED - DRIVER");
    end
`endif

endmodule

