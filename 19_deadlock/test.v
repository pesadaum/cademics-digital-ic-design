`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Arbiter - Unit 1 has priority but does not pre-empt a unit 2 grant.        //
////////////////////////////////////////////////////////////////////////////////

module arbiter (
  input  wire REQ1, REQ2,
  output reg  gnt1, gnt2
);

  initial begin
    gnt1 = 0;
    gnt2 = 0;
    forever begin
      @(REQ1 or REQ2);                // requests change
      gnt1 <= REQ1 && !REQ2           // no contention
        || REQ1 &&  REQ2 && !gnt2;    // 1 has priority
      gnt2 <= REQ2 && !REQ1           // no contention
        || REQ2 &&  REQ1 &&  gnt2;    // no pre-emption
    end
  end

endmodule


////////////////////////////////////////////////////////////////////////////////
// Requester - At random intervals needs one or the other or both resources.  //
////////////////////////////////////////////////////////////////////////////////

module requester #(parameter integer SEED=1) (
  input  wire GNTA, GNTB,
  output reg  REQA, REQB
);

// TO DO - Define a watchdog task that after a reasonable amount of time
//         (the solution uses 17 ns) drops both request signals and disables
//         the request loop. The request loop will immediately restart.
  task watchdog;
    begin
      #20;
      force REQA = 0;
      force REQB = 0;
      disable REQUEST.LOOP;
    end
  endtask


  initial begin : REQUEST
    integer seed;
    seed = SEED;
    REQA = 0;
    REQB = 0;
    forever begin : LOOP
      #($dist_uniform(seed,1,3));
      REQA = $random;
      REQB = $random;

      // TO DO - Change each wait statement to a parallel block that:
      //         - Enables the watchdog task
      //         - Waits for the grant and when it comes disables the task
      if (REQA)
        fork
          watchdog;
          wait (GNTA) disable watchdog;
        join
      if (REQB)
        fork
          watchdog;
          wait (GNTB) disable watchdog;
        join
        end
      end

    endmodule


////////////////////////////////////////////////////////////////////////////////
// Test - Instantiates two requesting units and two responding arbiters       //
////////////////////////////////////////////////////////////////////////////////

module test ();

      wire req1a, req1b, gnt1a, gnt1b;
      wire req2a, req2b, gnt2a, gnt2b;

  requester #(42) r1 (gnt1a,gnt1b,req1a,req1b); // requests A first
  requester #(86) r2 (gnt2b,gnt2a,req2b,req2a); // requests B first
  arbiter aa (req1a,req2a,gnt1a,gnt2a); // gives requester 1 priority
  arbiter ab (req2b,req1b,gnt2b,gnt1b); // gives requester 2 priority

      initial
        begin : MONITOR
          integer mcd;
          $timeformat (-9,0,"",4);
          mcd = $fopen("outfile.txt");
          $fdisplay (mcd,"time  r1 r2  g1 g2");
          $fmonitor (mcd,"%t  %b%b %b%b  %b%b %b%b",
            $time,req1a,req1b,req2a,req2b,gnt1a,gnt1b,gnt2a,gnt2b);
          #99 $finish;
        end

    endmodule
