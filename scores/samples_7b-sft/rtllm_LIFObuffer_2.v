
module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [2:0] SP;
 
reg [3:0] stack_mem [0:3];
 

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 3'b100;
 
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'b0;
        
        stack_mem[0] <= 4'b0;
        stack_mem[1] <= 4'b0;
        stack_mem[2] <= 4'b0;
        stack_mem[3] <= 4'b0;
    end
    else if (EN) begin
        if (!RW) begin 
            if (!FULL) begin
                SP <= SP - 1;
                stack_mem[SP] <= dataIn;
                
                EMPTY <= (SP - 1 == 3'b100);
                FULL <= (SP - 1 == 3'b000);
            end
        end
        else begin 
            if (!EMPTY) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
                
                EMPTY <= (SP + 1 == 3'b100);
                FULL <= (SP + 1 == 3'b000);
            end
        end
    end
end

endmodule
