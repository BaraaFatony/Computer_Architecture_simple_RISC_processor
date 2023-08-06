module Increment_Unit(
    input [31:0] In,
    output reg [31:0] Out
);

    always @(In) begin
        Out <= In + 1;
    end

endmodule
