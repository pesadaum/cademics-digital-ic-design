module tb_xor;

  reg A, B;
  wire Q;
  reg clk;

  my_xor dut(.A(A), .B(B), .Q(Q));

  task expect;
    input Q_exp;
    if (Q !== Q_exp) begin
      $display("TEST FAILED");
      $display("At time %0d A=%b B=%b Q=%b",
               $time, A, B, Q);
      $display("data_out should be %b", Q_exp);
      $finish;
    end
    else begin
      $display("At time %0d A=%b B=%b Q=%b",
               $time, A, B, Q);
    end
  endtask

  initial
    repeat (5) begin
      #5 clk=1;
      #5 clk=0;
    end

  initial
    @(negedge clk) begin

     A=1'b0;
     B=1'b0;
     @(clk) expect (1'b0);

     A=1'b0;
     B=1'b1;
     @(clk) expect (1'b1);

     A=1'b1;
     B=1'b0;
     @(clk) expect (1'b1);

     A=1'b1;
     B=1'b1;
     @(clk) expect (1'b0);


     A=1'b0;
     B=1'b0;
     @(clk) expect (1'b0);



     A=1'b0;
     B=1'b1;
     @(clk) expect (1'b0);

     $display("TEST PASSED");
     $finish;
   end

 endmodule
