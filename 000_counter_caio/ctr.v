/* 10 bit counter, possibility to count ascending and descending with async enable and reset */

module ctr #(parameter WIDTH = 10) (
  output reg [WIDTH-1:0] count         ,
  input                  clk           ,
  input                  enable        ,
  input                  count_reversed,
  input                  rst
);

  always @* begin: count_startup
    count = ~count_reversed;
  end

  always @(posedge clk or negedge rst or negedge enable) begin
    if (rst) count = 0;
    if (~enable) count = 0;


    if (enable && ~count_reversed) begin : count_ascending
      count <= count + 1;
    end

    else if (enable && count_reversed) begin: count_descending
      count <= count -1;

    end

  end

endmodule