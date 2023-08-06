module Mux2x1(
    input Sel,
    input [31:0] In0,
    input [31:0] In1,
    output reg [31:0] Out
);

    always @(Sel, In0, In1) begin
        if (Sel == 0)
            Out <= In0;
        else
            Out <= In1;
    end

endmodule

module Mux2x1_5(
    input Sel,
    input [4:0] In0,
    input [4:0] In1,
    output reg [4:0] Out
);

    always @(Sel, In0, In1) begin
        if (Sel == 0)
            Out <= In0;
        else
            Out <= In1;
    end

endmodule

module Mux4x1(
    input [1:0] Sel,
    input [31:0] In0,
    input [31:0] In1,
    input [31:0] In2,
    input [31:0] In3,
    output reg [31:0] Out
);

    always @(Sel, In0, In1, In2, In3) begin
        case (Sel)
            2'b00: Out <= In0;
            2'b01: Out <= In1;
            2'b10: Out <= In2;
            2'b11: Out <= In3;
        endcase
    end

endmodule
