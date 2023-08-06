`timescale 1ns/1ns

// `include "CPU.v"
// `include "Main_Control.v"
// `include "PC_Control.v"
// `include "ALU_Control.v"
// `include "Write_Control.v"

// `include "ALU.v"
// `include "Memory.v"
// `include "Register_File.v"
// `include "Stack.v"
// `include "PC.v"

// `include "Buffer.v"
// `include "Mux.v"

// `include "Extend.v"
// `include "Sign_Extend.v"
// `include "Zero_Extend.v"

// `include "Adder.v"
// `include "Increment_Unit.v"



module Test_Bench();

reg clk;
reg PcWr;
reg[4:0] opcode;
reg[1:0] Type, PCSrc; 
reg [2:0] ALUOp; 
reg [1:0] ALUSrc;
reg stop;
reg[31:0] ir_in, ir_out, pc_in, pc_out, A, B, B_Mux, ALU_R, Mem_Out, Stack_Out; 
reg zero, cmp_zero, carry, negative;
reg RegSrc, RegWr, MemRd, MemWr, WBData, ExtOp, StackPop, StackPush;  
reg [31:0] rs1, rs2, rd;


CPU cpu(clk);

initial begin
    clk = 0;
    forever begin
        #5 clk = ~clk;
    end	  
end
initial	 begin	   
	
	// write_control start after 1 cycle
	cpu.write_control.startSensitivity = 1'b0;
	
	// STACK
	cpu.stack.sp = 5'b00000;
	


    // inital values for registers	 
	cpu.register_file.Registers[0] = 32'h00000000;
    cpu.register_file.Registers[1] = 32'h00000001;
    cpu.register_file.Registers[2] = 32'h00000002;
    cpu.register_file.Registers[3] = 32'h00000003;
    cpu.register_file.Registers[4] = 32'h00000004;
    cpu.register_file.Registers[5] = 32'h00000005;	
	cpu.register_file.Registers[6] = 32'h00000001;

    // inital vlaues for memory	
	cpu.memory.Mem[0] = 32'h00000001;
    cpu.memory.Mem[1] = 32'h00000005;
    cpu.memory.Mem[2] = 32'h00000007;
    cpu.memory.Mem[3] = 32'h00000004;
	cpu.memory.Mem[4] = 32'h00000008;
	
	// instructions
	//cpu.instruction_memory.Mem[0] = 32'b00001_00010_00111_00011_000000000_00_0; // ADD R7, R2, R3	 : R2 = 2, R3 = 3
	//cpu.instruction_memory.Mem[1] = 32'b00010_00111_00110_00011_000000000_00_0; // SUB R6, R7, R3	 : R7 = 5, R3 = 3	   
	//cpu.instruction_memory.Mem[2] = 32'b00000_00110_01000_00000000001111_10_0; // ADDI R8, R6, 15   : R6 = 2
	//cpu.instruction_memory.Mem[3] = 32'b00011_00010_01111_00011_000000000_00_0; // CMP R15, R2, R3   : R2 = 2, R3 = 3
	
	// JAL F
	// NOP
	// F: ADD R7, R2, R3 : STOP BIT
	//cpu.instruction_memory.Mem[0] = 32'b00001_000000000000000000000010_01_0; // JAL F
	//cpu.instruction_memory.Mem[1] = 32'b00000000000000000000000000000000;  // NOP
	//cpu.instruction_memory.Mem[2] = 32'b00001_00010_00111_00011_000000000_00_1; // ADD R7, R2, R3 
	
	
	// SW then LW
    //cpu.instruction_memory.Mem[0] = 32'b00011_00000_00011_00000000000100_10_0; // SW R3, 4(R0)	 : R3 = 3
	//cpu.instruction_memory.Mem[1] = 32'b00010_00000_00101_00000000000100_10_0; // LW R5, 4(R0)	 : 4(R0) = 3	
	
	// BEQ 
	// PC_OLD = 0, PC_1 = PC_OLD + 1 = 1, PC_BRANCH = PC_1 + SIGN(IMM14) = 1 + 4 = 5
	//cpu.instruction_memory.Mem[0] = 32'b00100_00001_00110_00000000000100_10_0; // BEQ R1, R6	 : R1 = 1, R6 = 1
	
	// SLL and SLRV	 
	//cpu.instruction_memory.Mem[0] = 32'b00000_00010_00111_00000_00010_0000_11_0; // SLL R7, R2, 2 	: R2 = 2, R7 = R2 << 2
	//cpu.instruction_memory.Mem[1] = 32'b00011_00111_01000_00010_00000_0000_11_0; // SLRV R8, R7, R2 : R7 = 8, R2 = 2, R8 = R7 >> R2	
	
	
	
	// for simulation
	assign opcode = cpu.opcode;
	assign Type = cpu.Type;  
	assign stop = cpu.stop;
	assign ir_in = cpu.ir_in;
	assign ir_out = cpu.ir_out;
	assign pc_in = cpu.pc_in;
	assign pc_out = cpu.pc_out;	
	
	assign RegSrc   = cpu.RegSrc;
	assign RegWr    = cpu.RegWr;
	assign MemRd    = cpu.MemRd;
	assign MemWr    = cpu.MemWr;
	assign WBData   = cpu.WBData;
	assign ExtOp    = cpu.ExtOp;
	assign StackPop = cpu.StackPop;
	assign StackPush = cpu.StackPush;  
	
	
	assign zero     = cpu.zero;
	assign cmp_zero = cpu.cmp_zero;
	assign carry    = cpu.carry;
	assign negative = cpu.negative;	 
	
	assign PCSrc = cpu.PcSrc;  
	assign A = cpu.register_file_a_out;
	assign B = cpu.register_file_b_out;
	assign B_Mux = cpu.alu_source_mux_out;	  
	
	assign ALU_R = cpu.alu_result_out;
	assign Mem_Out = cpu.memory_out;
	assign Stack_Out = cpu.stack_out;
	
	assign ALUOp = cpu.ALUOp;
	assign ALUSrc = cpu.ALUSrc;
	
	
	assign rs1 = cpu.rs1;
	assign rs2 = cpu.rb_source_mux_out;
	assign rd = cpu.rd;	   
	
	
	assign PcWr = cpu.PcWr;
	


	
    


end



endmodule