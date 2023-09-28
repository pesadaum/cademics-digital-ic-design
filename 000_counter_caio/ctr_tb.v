module ctr_tb ();

  localparam WIDTH = 3;

  reg              clk           ;
  reg              rst           ;
  reg              enable        ;
  reg              count_reversed;
  wire [WIDTH-1:0] count         ;


  ctr #(.WIDTH(WIDTH)) ctr_inst (
    .clk           (clk           ),
    .rst           (rst           ),
    .enable        (enable        ),
    .count_reversed(count_reversed),
    .count         (count         )
  );

  task expect;
    input [WIDTH-1:0] exp_out;

    if (count !== exp_out) begin
      $display("TEST FAILED");
      $display("At time %0d rst=%b enable=%b count_reversed=%b, count=%d",
        $time, rst, enable, count_reversed, count);
      $display("counter should be %d", exp_out);
      // $finish;
    end

    else begin
      $display("At time %0d rst=%b enable=%b count_reversed=%b, count=%d",
        $time, rst, enable, count_reversed, count);
    end
  endtask

  initial begin
    rst = 1;
    enable = 0;
    count_reversed = 0;
    # 5;
  end

  integer i;
  initial
    repeat(2*(2**WIDTH)) begin
      #5 clk = 1'b0;
      #5 clk = 1'b1;
    end

  initial @(negedge clk) begin

    $display("testing ascending count\n");
    enable = 1; 
    rst = 0;
    for (i = 0; i < 2**WIDTH - 1; i = i+1) begin
      @ (posedge clk) expect(i+1);
    end

    $display("testing descending count\n");
    i = 2**WIDTH +1;
    rst = 1; rst = 0;
    count_reversed = 1;
    
    for (i = 2**WIDTH +1 ; i > -1; i = i-1) begin
      @ (posedge clk) expect(i+1);
    end

  end

endmodule