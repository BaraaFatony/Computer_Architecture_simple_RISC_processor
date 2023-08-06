module Zero_Extend(
    input [4:0] In,
    output reg [31:0] Out
);

    always @(In) begin
        Out <= {27'b0, In};
    end

endmodule
