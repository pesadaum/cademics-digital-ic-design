////////////////////////////////////////////////////////////////////////////////
// this compiles all units if none are specified                              //
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

////////////////////////////////////////////////////////////////////////////////
// priority encoder outputs number of highest priority input                  //
// lowest numbered input has highest priority                                 //
// this is a combinational block so should use blocking assignments           //
////////////////////////////////////////////////////////////////////////////////
`ifdef priority7
module priority7 ( y, a ) ;

  output reg  [2:0] y ;
  input  wire [7:1] a ;
  
  integer i;
  always @* begin
    y = 0;
    for (i=1; i < 8; i = i+1) begin
      if(a[i]) y = i;
    end
    end

endmodule
`endif


////////////////////////////////////////////////////////////////////////////////
// latch with active-high enable and active-low asynchronous reset and set    //
// set has priority over reset                                                //
// this is a combinational block modeling a sequential device                 //
// so must use nonblocking assignments                                        //
////////////////////////////////////////////////////////////////////////////////
`ifdef latchrs
module latchrs ( q, e, d, r, s ) ;

  output reg  q ;
  input  wire e, d, r, s ;

// do not remove comment below
// cadence async_set_reset "s, r"

    always @* begin
      if (!s) q <= 1; else
      if (!r) q <= 0; else
      if  (e) q <= d;
    end


endmodule
`endif


////////////////////////////////////////////////////////////////////////////////
// flop-flop with active-high clock and enable and                            //
// active-low asynchronous reset and set. set has priority over reset.        //
// this is a sequential block so must use nonblocking assignments             //
////////////////////////////////////////////////////////////////////////////////
`ifdef dffrs
module dffrs ( q, c, d, e, r, s ) ;

  output reg  q ;
  input  wire c, d, e, r, s ;

  // `r` signal must be first due to priority
  always @(posedge c, negedge r, negedge s) begin
    if(!s) q <= 1; else
    if(!r) q <= 0; else
    if (e) q <= d;
  end

endmodule
`endif


////////////////////////////////////////////////////////////////////////////////
// bus driver                                                                 //
// output is high-impedance when not enabled                                  //
// this is a combinational block                                              //
////////////////////////////////////////////////////////////////////////////////
`ifdef drive8
module drive8 ( y, a, e ) ;

  output reg  [7:0] y ;
  input  wire [7:0] a ;
  input  wire       e ;

  always @* begin
    if(e) y = a; else y = 'bZ;
  end

endmodule
`endif

