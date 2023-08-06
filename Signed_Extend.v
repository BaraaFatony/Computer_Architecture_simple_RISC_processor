module Sign_Extend(
  input [23:0] In,
  output reg [31:0] Out
);

  always @(In) begin
    if (In[23] == 1) 
      Out <= {8'b11111111, In}; 
    else
      Out <= {8'b00000000, In}; 
  end

endmodule
