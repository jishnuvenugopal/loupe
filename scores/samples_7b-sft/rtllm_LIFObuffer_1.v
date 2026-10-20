
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

reg [3:0] stack_mem [0:3];
 
reg [2:0] SP;
 

always @(posedge Clk) begin
    if (Rst) begin
        
        SP <= 4;
        EMPTY <= 1;
        FULL <= 0;
        stack_mem[0] <= 0;
        stack_mem[1] <= 0;
        stack_mem[2] <= 0;
        stack_mem[3] <= 0;
    end else if (EN) begin
        if (!FULL && !RW) begin 
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (!EMPTY && RW) begin 
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 0;
            SP <= SP + 1;
        end
        
        EMPTY <= (SP == 4);
        FULL <= (SP == 0);
    end
end

endmodule
