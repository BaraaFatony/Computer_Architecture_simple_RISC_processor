module Wrtie_Control(
    input [1:0] Type,
    input [4:0] OPCode,
    input Stop,
    input clk,
    output reg StackPush,
    output reg StackPop,
    output reg PcWrite,
    output reg RegWr,
    output reg MemWr
);

parameter Set = 1'b1;
parameter Reset = 1'b0;


reg [1:0] state;
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] counter; // for cycles delay
parameter C0 = 2'b00;
parameter C1 = 2'b01;
parameter C2 = 2'b10;
parameter C3 = 2'b11;

reg[2:0] operation;
parameter O0 = 3'b000; // AND, ADD, SUB, ANDI, ADDI, SLL, SLLV, SLR, SLRV
parameter O1 = 3'b001; // CMP
parameter O2 = 3'b010; // BEQ
parameter O3 = 3'b011; // LW
parameter O4 = 3'b100; // SW
parameter O5 = 3'b101; // J
parameter O6 = 3'b110; // JAL


reg startSensitivity;
reg [31:0] clockCount = 32'd0;

always @(posedge clk) begin	
	clockCount <= clockCount + 1;
	
	if(	startSensitivity ) begin 
		#1	  // delay 1ns
    case(state)
        S0: begin

           if (Type == 2'b00) begin
			    if (OPCode == 4'b0000 || OPCode == 4'b0001 || OPCode == 4'b0010)  // AND, ADD, SUB
			        operation = O0;
			    else if (OPCode == 4'b0011)	  // CMP
			        operation = O1;
			    
			end
			
			
			else if (Type == 2'b01) begin
			    if (OPCode == 4'b0000)	// J
			        operation = O5;
			    else if (OPCode == 4'b0001)	  // JAL
			        operation = O6;
			end	
			
			else if (Type == 2'b10) begin
			    if (OPCode == 4'b0100) // BEQ
			        operation = O2;
			    else if (OPCode == 4'b0010)	 // LW
			        operation = O3;
			    else if (OPCode == 4'b0011)	 // SW
			        operation = O4;
			end
			
			else if (Type == 2'b11) begin //  SLL, SLLV, SLR, SLRV
			        operation = O0;
			end

			

            StackPush = Reset;
            StackPop = Reset;
            PcWrite = Reset;
            RegWr = Reset;
            MemWr = Reset;
            
            if(
                (counter == C3 && (operation == O0 || operation == O3)) ||
                (counter == C2 && operation == O4) ||
                (counter == C1 && (operation == O1 || operation == O2)) ||
                (counter == C0 && (operation == O5 || operation == O6))
            ) begin
                
                state = S1;
                counter = C0;
            end
            else begin
                counter = counter + 1'b1; 
				
            end
           
        end
        S1: begin
            if (operation == O0 || operation == O3)
			    RegWr <= Set;
			else if (operation == O4)
			    MemWr <= Set;
			else if (operation == O6)
			    StackPush <= Set;

            
            
            if(Stop) begin
                StackPop <= Set;
            end  

            state <= S2;

        end

        S2: begin
			
            StackPush <= Reset;
            StackPop <= Reset;
            RegWr <= Reset;
            MemWr <= Reset;

            PcWrite <= Set;
            
            
            state <= S3;
        end	
		S3: begin
			PcWrite <= Reset;
			state <= S0;
			end


    endcase
	end
	else begin 
		// inital values for write_control 
		state <= S0;
        counter <= C0;
        operation <= O0;
		StackPush <= Reset;
        StackPop <= Reset;
        PcWrite <= Reset;
        RegWr <= Reset;
        MemWr <= Reset;
		
		startSensitivity <= Set;
		
	end
	

    
end





    

endmodule