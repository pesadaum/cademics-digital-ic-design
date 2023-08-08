module my_xor (A, B, Q);

  input A, B;
  output  Q;

  assign Q = (A | B) & (~A | ~B);

endmodule
