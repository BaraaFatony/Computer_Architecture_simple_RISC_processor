module Main_Control(
    input [1:0] Type,
    input [4:0] OPCode,
    output reg [1:0] ALUSrc,
    output reg RegSrc,
    output reg ExtOp,
    output reg MemRd,
    output reg WBData,
);


    always @(*) begin

        RegSrc <= (Type == 2'b10 && (OPCode == 5'b00011 || OPCode == 5'b00100));  // SW + BEQ
        ExtOp <= (Type == 2'b10) && (OPCode == 5'b00011 || OPCode == 5'b00100 || OPCode == 5'b00010 || OPCode == 5'b00001);  // SW + BEQ + LW + ADDI
        MemRd <= ((Type == 2'b10 && OPCode == 5'b00010));  // LW
        WBData <= ((Type == 2'b10 && OPCode == 5'b00010));  // LW


       ALUSrc <= (Type == 2'b00 && (OPCode == 5'b00000 || OPCode == 5'b00001 || OPCode == 5'b00010 || OPCode == 5'b00011)) ? 2'b00 : //AND, ADD, SUB, CMP
         (Type == 2'b10 && OPCode == 5'b00100) ? 2'b00 : //BEQ
         (Type == 2'b10 && (OPCode == 5'b00000 || OPCode == 5'b00001 || OPCode == 5'b00010 || OPCode == 5'b00011)) ? 2'b01 : //ANDI, ADDI, LW, SW
         (Type == 2'b11 && (OPCode == 5'b00000 || OPCode == 5'b00001)) ? 2'b10 : //SLL, SLR
         (Type == 2'b11 && (OPCode == 5'b00010 || OPCode == 5'b00011)) ? 2'b00 : //SLLV, SLRV
         2'b00; //Default to AND for unsupported OPCode



    end

endmodule