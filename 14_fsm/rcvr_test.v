module rcvr_test;

  localparam [1:14*8] message_send = "I Love Verilog" ;
  localparam [1:8] head = 8'hA5 ;

  reg        clock    ;
  reg        reset    ;
  reg        data_in  ;
  reg        reading  ;
  wire       ready    ;
  wire       overrun  ;
  wire [7:0] data_out ;

  rcvr rcvr_i (clock, reset, data_in, reading, ready, overrun, data_out);

  initial forever @(posedge overrun)
    $display("At time %0d: Data out buffer is overrun", $time);

  initial begin
      repeat (300) begin
          clock=1; #1;
          clock=0; #1;
        end
      $display("TEST TIMEOUT");
      $finish;
    end

  initial begin : XMT
      reg [1:8] body;
      integer i, j, seed;
      seed = 42;
      @(negedge clock) reset = 1; data_in = 0; reading = 0;
      @(negedge clock) reset = 0;
      $display("Message sending:  %s", message_send);
      for (i=1; i<=14; i=i+1) begin
          // wait random time between "packets"
          repeat ($dist_uniform(seed,0,8)) @(negedge clock);
          for (j=1; j<=8; j=j+1) @(negedge clock) data_in = head[j];
          body = message_send[i*8-:8];
          for (j=1; j<=8; j=j+1) @(negedge clock) data_in = body[j];
          $display("At time %0d: Put character \"%s\"", $time, body);
        end
    end

  initial begin : RCV
      reg [1:14*8] message_rcvd;
      integer i, seed;
      seed = 86;
      for (i=1; i<=14; i=i+1) begin
          @(posedge ready);
          // wait random time before retrieving "packet"
          repeat ($dist_uniform(seed,0,14)) @(negedge clock);
          @(negedge clock) reading = 1 ;
          @(negedge clock) reading = 0 ;
          $display("At time %0d: Got character \"%s\"", $time, data_out);
          message_rcvd[i*8-:8] = data_out ;
        end
      $display("Message received: %s", message_rcvd);
      $display("TEST DONE");
      $finish;
    end

endmodule
