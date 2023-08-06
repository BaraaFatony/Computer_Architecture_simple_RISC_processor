module ALU_Control(
    input [1:0] Type,
    input [4:0] OPCode,
    output reg [2:0] ALUOp
);


    always @(*) begin
        case (Type)
            2'b00: begin // R-Type
                case (OPCode)
                    5'b00000: ALUOp <= 3'b000; // AND
                    5'b00001: ALUOp <= 3'b001; // ADD
                    5'b00010: ALUOp <= 3'b010; // SUB
                    5'b00011: ALUOp <= 3'b010; // CMP
                    default: ALUOp <= 3'b000; // Default to AND for unsupported OPCode
                endcase
            end
            2'b01: begin // J-Type
                case (OPCode)
                    5'b00000, 5'b00001: ALUOp <= 3'b000; // X
                    default: ALUOp <= 3'b000; // Default to X for unsupported OPCode
                endcase
            end
            2'b10: begin // I-Type
                case (OPCode)
                    5'b00000: ALUOp <= 3'b000; // ANDI
                    5'b00001: ALUOp <= 3'b001; // ADDI
                    5'b00010: ALUOp <= 3'b001; // LW
                    5'b00011: ALUOp <= 3'b001; // SW
                    5'b00100: ALUOp <= 3'b010; // BEQ
                    default: ALUOp <= 3'b000; // Default to AND for unsupported OPCode
                endcase
            end
            2'b11: begin // S-Type
                case (OPCode)
                    5'b00000: ALUOp <= 3'b011; // SLL
                    5'b00001: ALUOp <= 3'b100; // SLR
                    5'b00010: ALUOp <= 3'b011; // SLLV
                    5'b00011: ALUOp <= 3'b100; // SLRV
                    default: ALUOp <= 3'b011; // Default to SLL for unsupported OPCode
                endcase
            end
            default: ALUOp <= 3'b000; // Default to X for unsupported Type
        endcase
    end




endmodule