module PC_Control(
    input [1:0] Type,
    input [4:0] OPCode,
    input Stop,
    input Zero,
    output reg [1:0] PcSrc
);

    always @(*) begin
        if (Stop)
            PcSrc <= 2'b00;
        else if (Type == 2'b10 && Zero && OPCode == 5'b00100)	// BEQ
            PcSrc <= 2'b01;
        else if (Type == 2'b01)	// J, JAL
            PcSrc <= 2'b10;
        else
            PcSrc <= 2'b11;
    end


endmodule