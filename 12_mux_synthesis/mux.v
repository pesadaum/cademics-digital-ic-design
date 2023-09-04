`ifndef USE_CASE
  `ifndef USE_IF
`define USE_IF
  `endif
`else
  `ifdef USE_IF
`undef USE_IF
  `endif
`endif

module mux (
  output reg        mux_out,
  input  wire       clock  ,
  input  wire [1:0] select ,
  input  wire       in1, in2, in3
);

  reg temp_reg;

  always @(posedge clock)
    mux_out <= temp_reg ;

  always @*

`ifdef USE_IF
    if      (select <= 1) temp_reg = in1;
    else if (select == 2) temp_reg = in2;
    else if (select >= 3) temp_reg = in3;
`endif

`ifdef USE_CASE
    case ( 1 )
      (select <= 1) : temp_reg = in1 ;
      (select == 2) : temp_reg = in2 ;
      (select >= 3) : temp_reg = in3 ;
    endcase
`endif

endmodule

`undef USE_CASE
`undef USE_IF
