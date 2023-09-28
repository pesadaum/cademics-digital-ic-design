module rcvr
(
  input  wire      clock   ,
  input  wire      reset   ,
  input  wire      data_in ,
  input  wire      reading ,
  output reg       ready   ,
  output reg       overrun ,
  output reg [7:0] data_out
);

  // For proper operation the FSM must hard-code the MATCH
  localparam [7:0] MATCH = 8'hA5 ; // 10100101

  reg [3:0] state ;

  // Opportunity for Gray encoding as path is mostly linear
  localparam [3:0] HEAD1=4'b0000, HEAD2=4'b0001, HEAD3=4'b0011, HEAD4=4'b0010,
                   HEAD5=4'b0110, HEAD6=4'b0111, HEAD7=4'b0101, HEAD8=4'b0100,
                   BODY1=4'b1100, BODY2=4'b1101, BODY3=4'b1111, BODY4=4'b1110,
                   BODY5=4'b1010, BODY6=4'b1011, BODY7=4'b1001, BODY8=4'b1000;

  reg [6:0] body_reg ;

  always @(posedge clock)

    if (reset) begin

        // CLEAR ALL CONTROL REGISTERS TO INACTIVE STATE (IGNORE DATA REGISTERS)




      end

    else begin

        // WHEN IN EACH STATE WHAT MOVES FSM TO WHAT NEXT STATE?
        case ( state )
















        endcase

        // IF STATE IS BODY? THEN SHIFT DATA INPUT LEFT INTO BODY REGISTER




        // IF STATE IS BODY8 THEN COPY CONCATENATION OF BODY REGISTER AND INPUT
        // DATA TO OUTPUT REGISTER


        // IF STATE IS BODY8 THEN SET READY ELSE IF READING THEN CLEAR READY


        // IF READING THEN CLEAR OVERRUN, ELSE
        // IF STATE IS BODY8 AND STILL READY THEN SET OVERRUN


      end

endmodule
