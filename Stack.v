module Stack(
    input [31:0] In,
    input clk,
    input StackPush,
    input StackPop,
    output reg [31:0] Out
);

    reg [31:0] stack [0:31]; // Stack memory with 32 elements
    reg [4:0] sp; // Stack pointer

    
  
    
    
    always @(posedge clk) begin
        if (StackPush) begin
            if (sp < 32) begin
                stack[sp] = In; // Push data onto stack
                sp = sp + 1; // Increment stack pointer
            end
        end 
        else if (StackPop) begin
            if (sp > 0) begin
                sp = sp - 1; // Decrement stack pointer
                Out = stack[sp]; // Pop data from stack
                stack[sp] = 0; // Clear popped data
                
            end
        end
  end

endmodule