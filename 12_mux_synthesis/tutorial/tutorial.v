module buf1  ( A, Y ) ;
  input  wire A ;
  output wire Y ;
  assign Y = A ;
endmodule

module inv1  ( A, Y ) ;
  input  wire A ;
  output wire Y ;
  assign Y = ~A ;
endmodule

module ivt1  ( A, E, Y ) ;
  input  wire A ;
  input  wire E ;
  output wire Y ;
  assign Y = E ? ~A : 1'bZ ;
endmodule

module nand2 ( A, B, Y ) ;
  input  wire A ;
  input  wire B ;
  output wire Y ;
  assign Y = ~( A & B ) ;
endmodule

module nor2 ( A, B, Y ) ;
  input  wire A ;
  input  wire B ;
  output wire Y ;
  assign Y = ~( A | B ) ;
endmodule

module xor2 ( A, B, Y ) ;
  input  wire A ;
  input  wire B ;
  output wire Y ;
  assign Y = ( A ^ B ) ;
endmodule

primitive udp_latchdrs (q,d,e,r,s);
output q; reg q;
input d,e,r,s;
  table
  // d e r s : q : qnext
     ? ? ? 0 : ? : 1 ; // set wins
     ? ? 0 1 : ? : 0 ; // rst
     ? 0 1 p : ? : - ; // set posedge
     ? 0 p 1 : ? : - ; // rst posedge
     0 1 1 1 : ? : 0 ; // enabled 0
     1 1 1 1 : ? : 1 ; // enabled 1
     ? 0 1 1 : ? : - ; // disabled
     0 ? ? 1 : 0 : - ; // pessimism
     1 ? 1 ? : 1 : - ; // pessimism
  endtable
endprimitive

module latchd ( D, ENA, Q ) ;
  input  wire D   ;
  input  wire ENA ;
  output wire Q   ;
  udp_latchdrs (Q,D,ENA,1'b1,1'b1);
endmodule

module latchdrs ( D, ENA, R, S, Q ) ;
  input  wire D   ;
  input  wire ENA ;
  input  wire R   ;
  input  wire S   ;
  output wire Q   ;
  udp_latchdrs (Q,D,ENA,R,S);
endmodule

primitive udp_flopdrs (q,d,c,r,s);
  output q; reg q;
  input d,c,r,s;
  table
  // d c r s : q : qnext
     ? ? ? 0 : ? : 1; // set wins
     ? ? 0 1 : ? : 0; // rst
     ? ? 1 p : ? : -; // set posedge
     ? ? p 1 : ? : -; // rst posedge
     0 r 1 1 : ? : 0; // clk rise d=0
     1 r 1 1 : ? : 1; // clk rise d=1
     0 p 1 1 : 0 : -; // clk pos  d=0
     1 p 1 1 : 1 : -; // clk pos  d=1
     ? n ? ? : ? : -; // clk negedge
     * ? ? ? : ? : -; // data edge
  endtable
endprimitive

primitive udp_flopdrs_ckn (q,d,c,r,s);
  output q; reg q;
  input d,c,r,s;
  table
  // d c r s : q : qnext
     ? ? ? 0 : ? : 1; // set wins
     ? ? 0 1 : ? : 0; // rst
     ? ? 1 p : ? : -; // set posedge
     ? ? p 1 : ? : -; // rst posedge
     0 f 1 1 : ? : 0; // clk fall d=0
     1 f 1 1 : ? : 1; // clk fall d=1
     0 n 1 1 : 0 : -; // clk neg  d=0
     1 n 1 1 : 1 : -; // clk neg  d=1
     ? p ? ? : ? : -; // clk posedge
     * ? ? ? : ? : -; // data edge
  endtable
endprimitive

module fflopd ( D, CK, Q ) ;
  input  wire D  ;
  input  wire CK ;
  output wire Q  ;
  udp_flopdrs (Q,D,CK,1'b1,1'b1);
endmodule

module fflopd_ckn ( D, CK, Q ) ;
  input  wire D  ;
  input  wire CK ;
  output wire Q  ;
  udp_flopdrs_ckn (Q,D,CK,1'b1,1'b1);
endmodule

module flopdrs ( D, CK, R, S, Q ) ;
  input  wire D  ;
  input  wire CK ;
  input  wire R  ;
  input  wire S  ;
  output wire Q  ;
  udp_flopdrs (Q,D,CK,R,S);
endmodule

module flopdrs_ckn ( D, CK, R, S, Q ) ;
  input  wire D  ;
  input  wire CK ;
  input  wire R  ;
  input  wire S  ;
  output wire Q  ;
  udp_flopdrs_ckn (Q,D,CK,R,S);
endmodule

