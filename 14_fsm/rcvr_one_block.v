module rcvr (
  input  wire       clock   ,
  input  wire       reset   ,
  input  wire       data_in ,
  input  wire       reading ,
  output reg        ready   ,
  output reg        overrun ,
  output reg  [7:0] data_out
);

  // For proper operation the FSM must hard-code the MATCH
  localparam [7:0] MATCH = 8'hA5; // 10100101

  reg [3:0] state;

  // Opportunity for Gray encoding as path is mostly linear
  localparam [3:0] HEAD1=4'b0000, HEAD2=4'b0001, HEAD3=4'b0011, HEAD4=4'b0010,
    HEAD5=4'b0110, HEAD6=4'b0111, HEAD7=4'b0101, HEAD8=4'b0100,
    BODY1=4'b1100, BODY2=4'b1101, BODY3=4'b1111, BODY4=4'b1110,
    BODY5=4'b1010, BODY6=4'b1011, BODY7=4'b1001, BODY8=4'b1000;

  reg [6:0] body_reg;

  always @(posedge clock)

    if (reset) begin
      // CLEAR ALL CONTROL REGISTERS TO INACTIVE STATE (IGNORE DATA REGISTERS)
      ready   <= 1'b0;
      overrun <= 1'b0;
      state   <= HEAD1;
    end

    else begin
      // WHEN IN EACH STATE WHAT MOVES FSM TO WHAT NEXT STATE?
      case ( state )
        HEAD1   : state <= (data_in == 1'b1) ? HEAD2 : HEAD1;
        HEAD2   : state <= (data_in == 1'b0) ? HEAD3 : HEAD2;
        HEAD3   : state <= (data_in == 1'b1) ? HEAD4 : HEAD1;
        HEAD4   : state <= (data_in == 1'b0) ? HEAD5 : HEAD2;
        HEAD5   : state <= (data_in == 1'b0) ? HEAD6 : HEAD4;
        HEAD6   : state <= (data_in == 1'b1) ? HEAD7 : HEAD1;
        HEAD7   : state <= (data_in == 1'b0) ? HEAD8 : HEAD2;
        HEAD8   : state <= (data_in == 1'b1) ? BODY1 : HEAD1;
        BODY1   : state <= BODY2;
        BODY2   : state <= BODY3;
        BODY3   : state <= BODY4;
        BODY4   : state <= BODY5;
        BODY5   : state <= BODY6;
        BODY6   : state <= BODY7;
        BODY7   : state <= BODY8;
        BODY8   : state <= HEAD1;
        default : state <= HEAD1;
      endcase

      // IF STATE IS BODY? THEN SHIFT DATA INPUT LEFT INTO BODY REGISTER
      case (state)
        BODY1,
        BODY2,
        BODY3,
        BODY4,
        BODY5,
        BODY6,
        BODY7,
        BODY8 : body_reg <= {body_reg, data_in};
      endcase

      // IF STATE IS BODY8 THEN COPY CONCATENATION OF BODY REGISTER AND INPUT
      // DATA TO OUTPUT REGISTER
      if (state == BODY8) data_out <= {body_reg, data_in};


      // IF STATE IS BODY8 THEN SET READY ELSE IF READING THEN CLEAR READY
      if(state == BODY8) ready <= 1'b1;
      else if (reading)  ready <= 1'b0;

      // IF READING THEN CLEAR OVERRUN, ELSE
      // IF STATE IS BODY8 AND STILL READY THEN SET OVERRUN
      if (reading) overrun <= 1'b0;
      else if ((state == BODY8) && ready) overrun <= 1'b1;


    end

endmodule
