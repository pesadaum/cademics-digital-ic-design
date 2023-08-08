module alu #(
    parameter WIDTH = 8
  ) (
    in_a, in_b, opcode, alu_out, a_is_zero
  );

  input [WIDTH-1:0] in_a, in_b;
  input [2:0] opcode;
  output reg [WIDTH-1:0] alu_out;
  output a_is_zero;

  assign a_is_zero = in_a == 0;
  always @* begin
    case (opcode)
      3'b000:
        alu_out = in_a;        // HLT
      3'b001:
        alu_out = in_a;        // SKZ
      3'b010:
        alu_out = in_a + in_b; // ADD
      3'b011:
        alu_out = in_a & in_b; // AND
      3'b100:
        alu_out = in_a ^ in_b; // XOR
      3'b101:
        alu_out =  in_b;       // LDA
      3'b110:
        alu_out = in_a;        // STO
      3'b111:
        alu_out = in_a;        // JMP
      default:
        alu_out = 8'bZ;
    endcase

  end




endmodule
