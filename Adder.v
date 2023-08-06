module Adder(
    input [31:0] In0,
    input [31:0] In1,
    output reg [31:0] Out
);

    always @(In0, In1) begin
        Out <= In0 + In1;
    end

endmodule

