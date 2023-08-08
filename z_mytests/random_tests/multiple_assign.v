module mymod (
    a, b, c, x, ux
  );

  input a, b, c;
  output wire x, ux;

  
  assign x = a & b;
  // assign x = b;
  // assign x = c;
  // this prevents ux from being driven for multiple drivers but uwire must not be a port
  // uwire ux; 
  assign ux = x;

endmodule
