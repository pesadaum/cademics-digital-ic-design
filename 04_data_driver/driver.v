module driver #(parameter WIDTH = 8) (
  input  [WIDTH-1:0] data_in ,
  input              data_en ,
  output [WIDTH-1:0] data_out
);

  // `data_out` must be wire to be driven continuously
  assign data_out = data_en ? data_in : 8'bZ;


endmodule
