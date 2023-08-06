module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output reg Zero,
    output reg CMP_ZERO,
    output reg Carry,
    output reg Negative,
    output reg [31:0] Result
);

    initial Zero = 0;
    initial CMP_ZERO = 0;
    initial Carry = 0;
    initial Negative = 0;
    initial Result = 0;

    
    reg [31:0] temp;
    reg carry_out;

    always @(ALUOp or A or B) begin
        case(ALUOp)
            3'b000:	 begin
                temp = A & B;
                carry_out = 0; // No carry in AND operation		 
				end
            3'b001:	  begin
			
                temp = A + B;
                carry_out = (A[31] && B[31]) || (A[31] && ~temp[31]) || (B[31] && ~temp[31]); 
				end
            3'b010:	  begin
                temp = A - B;
                carry_out = (A[31] && ~B[31] && ~temp[31]) || (~A[31] && B[31] && temp[31]); 
				end
            3'b011: begin
                temp = A << B;
                carry_out = A << B; // Carry of shift left
				end
            3'b100:	begin
                temp = A >> B;
                carry_out = 0; // No carry in shift right operation	
				end
            default: begin
                temp = 0;
                carry_out = 0; 
				end
        endcase
        Result <= temp;
        Zero <= temp == 0;
        CMP_ZERO <= A < B;
        Negative <= temp < 0;
        Carry <= carry_out;
    end
endmodule