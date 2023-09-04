module latch_adder (
  input      a, b, enb,
  output reg c
);

  always @* begin
    wait(enb)      c = a+b;
  end

endmodule