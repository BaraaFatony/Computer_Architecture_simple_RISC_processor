module Register_File(
    input [4:0] RA,
    input [4:0] RB,
    input [4:0] RW,

    input [31:0] BusW,
    input RegWr,
    input clk,

    output reg [31:0] BusA,
    output reg [31:0] BusB
);

    reg [31:0] Registers [31 : 0];
   

    always @(posedge clk) begin
        if (RegWr & RW != 0) begin // No write on register zero just read from it
            Registers[RW] <= BusW;
        end	
		Registers[0] <= 0; 
    end		   
	
	

    always @(*) begin
        BusA <= Registers[RA];
    end
    
     always @(*) begin
        BusB <= Registers[RB];
    end




endmodule