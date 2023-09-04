module counter #(parameter WIDTH = 5) (
  input                  enab, load, clk, rst,
  input      [WIDTH-1:0] cnt_in ,
  output reg [WIDTH-1:0] cnt_out
);

  // not sure if "code in separate blocks is using separate `always` blocks"
  reg [WIDTH-1:0] cnt_aux;
  always @* begin
    if       (rst)  cnt_aux = 0;
    else  if (load) cnt_aux = cnt_in;
    else  if (enab) cnt_aux = cnt_out + 1;
    else            cnt_aux = cnt_out;
  end

  always @(posedge clk ) cnt_out <= cnt_aux ;


endmodule