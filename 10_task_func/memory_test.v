`timescale 1ns/1ps

module memory_test;

  localparam integer AWIDTH = 5;
  localparam integer DWIDTH = 8;

  reg               clk  ;
  reg               wr   ;
  reg               rd   ;
  reg  [AWIDTH-1:0] addr ;
  wire [DWIDTH-1:0] data ;
  reg  [DWIDTH-1:0] rdata;

  assign data = rdata;

  memory #(
    .AWIDTH(AWIDTH),
    .DWIDTH(DWIDTH)
  ) memory_inst (
    .clk (clk ),
    .wr  (wr  ),
    .rd  (rd  ),
    .addr(addr),
    .data(data)
  );

  task expect;
    input [DWIDTH-1:0] exp_data;
    if (data !== exp_data) begin
      $display("TEST FAILED");
      $display("At time %0d addr=%b data=%b", $time, addr, data);
      $display("data should be %b", exp_data);
      $finish;
    end
    else begin
      $timeformat(-9, 0,"ns", 4);
      $display("%t addr=%b, exp_data= %b, data=%b", $time, addr, exp_data, data);
    end
  endtask

////////////////////////////////////////////
//TO-DO: CODE THE WRITE TASK AS INSTRUCTED//
////////////////////////////////////////////

  task write
    (
      input [AWIDTH-1:0] addr,
      input [DWIDTH-1:0] data
    );
    begin
      wr=1; rd=0;
      memory_test.addr = addr;
      rdata = data;
      @(negedge clk);
    end
  endtask


////////////////////////////////////////////
//TO-DO: CODE THE READ TASK AS INSTRUCTED///
////////////////////////////////////////////

  task read
    (
      input [AWIDTH-1:0] addr,
      input [DWIDTH-1:0] data
    );
    begin
      wr=0; rd=1;
      memory_test.addr = addr;
      rdata = 'bZ;
      @(negedge clk) expect(data);
    end
  endtask


  initial repeat (67) begin #5 clk=1; #5 clk=0; end

  initial @(negedge clk) begin : TEST
    reg [AWIDTH-1:0] addr;
    reg [DWIDTH-1:0] data;

    addr=-1; data=0;
    while ( addr ) begin
      write(addr,data);
      addr=addr-1;
      data=data+1;
    end
    addr=-1; data=0;
    while ( addr ) begin
      read(addr,data);
      addr=addr-1;
      data=data+1;
    end
    $display("TEST PASSED");
    $finish;
  end

endmodule
