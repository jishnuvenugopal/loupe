
module LIFObuffer (
    input wire [3:0] dataIn,    
    input wire RW,              
    input wire EN,              
    input wire Rst,             
    input wire Clk,             
    output wire EMPTY,          
    output wire FULL,           
    output wire [3:0] dataOut   
);

    
    reg [3:0] stack_mem [3:0];

    
    reg [1:0] SP;

    
    assign EMPTY = (SP == 4);
    assign FULL = (SP == 0);

    
    always @(posedge Clk) begin
        if (Rst) begin
            
            SP <= 4;
            stack_mem <= '{4'b0000, 4'b0000, 4'b0000, 4'b0000};
        end else if (EN) begin
            if (RW == 0) begin  
                if (!FULL) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP - 1;
                end
            end else if (RW == 1) begin  
                if (!EMPTY) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0000;
                    SP <= SP + 1;
                end
            end
        end
    end

endmodule
