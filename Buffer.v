module Buffer_Register(
    input [31:0] In,
    input clk,
    output reg [31:0] Out
);

    reg [31:0] Register;
    initial begin
        Register = 0;
    end
    

    always @(posedge clk) begin
        Register <= In;
    end

    always @(*) begin
        Out <= Register;
    end

endmodule
