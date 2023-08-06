module CPU (
    input clk
);

// Wires

// 32 bit wires
wire [31:0] pc_in,
            pc_out,
            pc_inc,
            ir_in,
            ir_out,
            b_jp_out,
            b_pc_out,
            zero_extend_out,
            sign_extend_out,
            extend_out,
            sign_extend_adder_out,
            extend_adder_out,
            stack_out,
            register_file_a_out,
            register_file_b_out,
            b_pp_out,
            b_br_out,
            b_jm_out,
            b_im_out,
            b_sa_out,
            b_a_out,
            b_b_out,
            alu_source_mux_out,
            alu_zero_out,
            alu_cmp_zero_out,
            alu_carry_out,
            alu_negative_out,
            alu_result_out,
            b_r_out,
            b_d_out,
            memory_out,
            memory_destination_mux_out,
            b_w_out;

// immediate wires
wire [13:0] imm14;
assign imm14 = ir_out[16:3];
wire [23:0] imm24;
assign imm24 = ir_out[26:3];

// sa wire
wire [4:0] sa;
assign sa = ir_out[11:7];

// 5 bit wires (for register file)
wire [4:0] rs1,
           rs2,
           rd,
           rb_source_mux_out;

assign rs1 = ir_out[26:22];
assign rs2 = ir_out[16:12];
assign rd = ir_out[21:17];


// control units input wires
wire [4:0] opcode;
assign opcode = ir_out[31:27];
wire [1:0] Type;
assign Type = ir_out[2:1];
wire stop;
assign stop = ir_out[0];

// alu signals wires
wire zero, cmp_zero, carry, negative;

// main control unit signals wires
wire RegSrc, ExtOp, MemRd, WBData;
wire [1:0] ALUSrc;

// alu control unit signals wires
wire [2:0] ALUOp;

// pc control unit signals wires
wire [1:0] PcSrc;

// write control unit signals wires
wire RegWr, MemWr, StackPush, StackPop, PcWr;



// Units

// Fetch Stage (1)

PC pc(
    .In(pc_in),
    .clk(clk),
    .PcWr(PcWr),
    .Out(pc_out)
);

Increment_Unit increment_unit(
    .In(pc_out),
    .Out(pc_inc)
);

Memory instruction_memory(
    .Address(pc_out),
    .In(32'd0),
    .MemWr(1'b0),
    .MemRd(1'b1),
    .clk(clk),
    .Out(ir_in)
);

Mux4x1 pc_mux(
    .In0(b_pp_out),
    .In1(b_br_out),
    .In2(b_jm_out),
    .In3(pc_inc),
    .Sel(PcSrc),
    .Out(pc_in)
);

// Stage 1-2 Buffers

Buffer_Register ir(
    .In(ir_in),
    .clk(clk),
    .Out(ir_out)
);

Buffer_Register b_jp(
    .In(pc_out),
    .clk(clk),
    .Out(b_jp_out)
);

Buffer_Register b_pc(
    .In(pc_inc),
    .clk(clk),
    .Out(b_pc_out)
);

// Decode Stage (2)

Mux2x1_5 rb_source_mux(
    .In0(rs2),
    .In1(rd),
    .Sel(RegSrc),
    .Out(rb_source_mux_out)
);

Zero_Extend zero_extend(
    .In(sa),
    .Out(zero_extend_out)
);

Sign_Extend sign_extend(
    .In(imm24),
    .Out(sign_extend_out)
);
Extend extend(
	.In(imm14),	 
	.ExtOp(ExtOp),
    .Out(extend_out)
);

Adder sign_extend_adder(
    .In0(sign_extend_out),
    .In1(b_jp_out),
    .Out(sign_extend_adder_out)
);

Adder extend_adder(
    .In0(extend_out),
    .In1(b_pc_out),
    .Out(extend_adder_out)
);

Stack stack(
    .In(b_pc_out),
    .StackPush(StackPush),
    .StackPop(StackPop),
    .clk(clk),
    .Out(stack_out)
);


Register_File register_file(
    .RA(rs1),
    .RB(rb_source_mux_out),
    .RW(rd),
    .BusW(b_w_out),
    .RegWr(RegWr),
    .clk(clk),
    .BusA(register_file_a_out),
    .BusB(register_file_b_out)
);


// Control units

Main_Control main_control(
    .Type(Type),
    .OPCode(opcode),
    .ALUSrc(ALUSrc),
    .RegSrc(RegSrc),
    .ExtOp(ExtOp),
    .MemRd(MemRd),
    .WBData(WBData)
);

PC_Control pc_control(
    .Type(Type),
    .OPCode(opcode),
    .Stop(stop),
    .Zero(zero),
    .PcSrc(PcSrc)
);


ALU_Control alu_control(
    .Type(Type),
    .OPCode(opcode),
    .ALUOp(ALUOp)
);


Wrtie_Control write_control(
    .Type(Type),
    .OPCode(opcode),
    .Stop(stop),
    .clk(clk),
    .StackPush(StackPush),
    .StackPop(StackPop),
    .PcWrite(PcWr),
    .RegWr(RegWr),
    .MemWr(MemWr)
);

// Stage 2-3 Buffers

Buffer_Register b_pp(
    .In(stack_out),
    .clk(clk),
    .Out(b_pp_out)
);

Buffer_Register b_br(
    .In(extend_adder_out),
    .clk(clk),
    .Out(b_br_out)
);

Buffer_Register b_jm(
    .In(sign_extend_adder_out),
    .clk(clk),
    .Out(b_jm_out)
);

Buffer_Register b_im(
    .In(extend_out),
    .clk(clk),
    .Out(b_im_out)
);

Buffer_Register b_sa(
    .In(zero_extend_out),
    .clk(clk),
    .Out(b_sa_out)
);


Buffer_Register b_a(
    .In(register_file_a_out),
    .clk(clk),
    .Out(b_a_out)
);

Buffer_Register b_b(
    .In(register_file_b_out),
    .clk(clk),
    .Out(b_b_out)
);

// Execution Stage (3)

Mux4x1 alu_source_mux(
    .In0(b_b_out),
    .In1(b_im_out),
    .In2(b_sa_out),
    .In3(32'b0),
    .Sel(ALUSrc),
    .Out(alu_source_mux_out)
);

ALU alu(
    .A(b_a_out),
    .B(alu_source_mux_out),
    .ALUOp(ALUOp),
    .Zero(zero),
    .CMP_ZERO(cmp_zero),
    .Carry(carry),
    .Negative(negative),
    .Result(alu_result_out)
);

// Stage 3-4 Buffers

Buffer_Register b_r(
    .In(alu_result_out),
    .clk(clk),
    .Out(b_r_out)
);

Buffer_Register b_d(
    .In(b_b_out),
    .clk(clk),
    .Out(b_d_out)
);

// Memory Stage (4)

Memory memory(
    .Address(b_r_out),
    .In(b_d_out),
    .MemWr(MemWr),
    .MemRd(MemRd),
    .clk(clk),
    .Out(memory_out)
);

Mux2x1 memory_destination_mux(
    .In0(b_r_out),
    .In1(memory_out),
    .Sel(WBData),
    .Out(memory_destination_mux_out)
);

// Stage 4-5 Buffers

Buffer_Register b_w(
    .In(memory_destination_mux_out),
    .clk(clk),
    .Out(b_w_out)
);













endmodule
