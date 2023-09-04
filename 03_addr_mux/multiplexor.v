module multiplexor #(parameter WIDTH=5) (
  input  wire             sel    ,
  input  wire [WIDTH-1:0] in0, in1,
  output reg  [WIDTH-1:0] mux_out
);

  always @(in0, in1, sel) begin
    // this design does not concerns about X-pessimism
    mux_out = sel? in1 : in0;

  end

endmodule
