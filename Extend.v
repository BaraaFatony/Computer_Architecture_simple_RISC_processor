module Extend(
  input [13:0] In,
  input ExtOp,
  output reg [31:0] Out
);

  always @(*) begin
    Out[13:0] <= In[13:0];
    Out[31:14] <= (ExtOp&In[13])*(2**(18));
  end

endmodule
