
module LIFObuffer (
    input [3:0] dataIn,    
    input RW,              
    input EN,              
    input Rst,             
    input Clk,             
    output reg EMPTY,     
    output reg FULL,      
    output reg [3:0] dataOut  
);

    reg [1:0] SP;
          
    reg [3:0] stack_mem [3:0];
 

    always @(posedge Clk) begin
        if (Rst) begin
            
            SP <= 4;
            stack_mem <= 4'b0000;
            EMPTY <= 1;
            FULL <= 0;
        end else if (EN) begin
            
            if (!RW && !FULL) begin
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
                if (SP == 0)
                    EMPTY <= 1;
                FULL <= 0;
            end
            
            else if (RW && !EMPTY) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0000;
                SP <= SP + 1;
                if (SP == 4)
                    FULL <= 1;
                EMPTY <= 0;
            end
        end
    end

endmodule
