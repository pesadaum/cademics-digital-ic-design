module memory #(parameter AWIDTH = 5, DWIDTH = 8) (
  input wire              clk, rd, wr,
  input wire [AWIDTH-1:0] addr,
  inout wire [DWIDTH-1:0] data
);

  reg [DWIDTH-1:0] mem[0:2**AWIDTH-1];

  always @(posedge clk) begin
    if(wr) mem[addr] = data;
  end
  
  // first condition prevents reading and writing at the same time
  assign data = (wr && rd) ? 'bZ : rd ? mem[addr] : 'bZ;

endmodule