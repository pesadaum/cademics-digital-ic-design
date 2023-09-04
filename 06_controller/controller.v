module controller (
  input  wire       zero, clk, rst, // rst and clock are missing on testbenching
  input  wire [2:0] opcode, phase,
  output reg        sel, rd, ld_ir, halt, inc_pc, ld_ac, wr, ld_pc, data_e
);

  // OPCODEs encoding
  localparam integer
    HLT=0,
    SKZ=1,
    ADD=2,
    AND=3,
    XOR=4,
    LDA=5,
    STO=6,
    JMP=7;

  // Phases encoding
  localparam integer
    INST_ADDR = 0,
    INST_FETCH = 1,
    INST_LOAD = 2,
    IDLE = 3,
    OP_ADDR = 4,
    OP_FETCH = 5,
    ALU_OP = 6,
    STORE = 7;

  // Execution cycle conditions
  reg HLT_COND, ALU_COND, SKZ_COND, JMP_COND, STO_COND;

  always @* begin

    // if (rst); begin // reset procedure end
    /* since the reset is unconditional, it doesn't make sense to implement */

    // Mapping conditions for execution cycle
    ALU_COND = opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA;
    SKZ_COND = opcode == SKZ && zero;
    HLT_COND = opcode == HLT;
    JMP_COND = opcode == JMP;
    STO_COND = opcode == STO;

    case (phase)
      INST_ADDR :
        begin
          sel    = 1;
          rd     = 0;
          ld_ir  = 0;
          halt   = 0;
          inc_pc = 0;
          ld_ac  = 0;
          ld_pc  = 0;
          wr     = 0;
          data_e = 0;
        end
      INST_FETCH :
        begin
          sel    = 1;
          rd     = 1;
          ld_ir  = 0;
          halt   = 0;
          inc_pc = 0;
          ld_ac  = 0;
          ld_pc  = 0;
          wr     = 0;
          data_e = 0;
        end
      INST_LOAD :
        begin
          sel    = 1;
          rd     = 1;
          ld_ir  = 1;
          halt   = 0;
          inc_pc = 0;
          ld_ac  = 0;
          ld_pc  = 0;
          wr     = 0;
          data_e = 0;
        end
      IDLE :
        begin
          sel    = 1;
          rd     = 1;
          ld_ir  = 1;
          halt   = 0;
          inc_pc = 0;
          ld_ac  = 0;
          ld_pc  = 0;
          wr     = 0;
          data_e = 0;
        end
      OP_ADDR :
        begin
          sel    = 0;
          rd     = 0;
          ld_ir  = 0;
          halt   = HLT_COND;
          inc_pc = 1;
          ld_ac  = 0;
          ld_pc  = 0;
          wr     = 0;
          data_e = 0;
        end
      OP_FETCH :
        begin
          sel    = 0;
          rd     = ALU_COND;
          ld_ir  = 0;
          halt   = 0;
          inc_pc = 0;
          ld_ac  = 0;
          ld_pc  = 0;
          wr     = 0;
          data_e = 0;
        end
      ALU_OP :
        begin
          sel    = 0;
          rd     = ALU_COND;
          ld_ir  = 0;
          halt   = 0;
          inc_pc = SKZ_COND;
          ld_ac  = 0;
          ld_pc  = JMP_COND;
          wr     = 0;
          data_e = STO_COND;
        end
      STORE :
        begin
          sel    = 0;
          rd     = ALU_COND;
          ld_ir  = 0;
          halt   = 0;
          inc_pc = 0;
          ld_ac  = ALU_COND;
          ld_pc  = JMP_COND;
          wr     = STO_COND;
          data_e = STO_COND;
        end
      // default is phase 0 (INST_ADDR or reset phase)
      default :
        begin
          sel = 1;
          {rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = 0;
        end
    endcase
  end
endmodule
