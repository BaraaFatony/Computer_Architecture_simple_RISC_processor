module Memory(
    input [31:0] Address,
    input [31:0] In,
    input MemWr,
    input MemRd,
    input clk,
    output reg [31:0] Out
);


// it should be 2**32 bit
reg[31:0] Mem[4095 : 0];	

   

    always @(posedge clk) begin
        if(MemWr)
            Mem[Address] <= In;
    end

    always @(*) begin 
        if(MemRd)
            Out <= Mem[Address];
    end


endmodule