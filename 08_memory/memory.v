module memory #(parameter AWIDTH = 5, DWIDTH = 8) (
  input              clk, rd, wr,
  input [AWIDTH-1:0] addr,
  inout [DWIDTH-1:0] data
);

  always @(posedge clk) begin
    if(rd) begin
      data[addr] = 1;
    end

  end

endmodule