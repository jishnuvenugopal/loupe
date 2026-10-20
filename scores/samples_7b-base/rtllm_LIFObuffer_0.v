
module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg [3:0] dataOut,
    output reg EMPTY,
    output reg FULL
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;
 

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4;
 
        dataOut <= 4'b0000;
 
        EMPTY <= 1;
 
        FULL <= 0;
 
        stack_mem <= {4{4'b0000}};
 
    end else if (EN) begin
        if (SP != 4) begin 
            if (!RW) begin 
                stack_mem[SP] <= dataIn;
 
                SP <= SP - 1;
 
            end else if (!FULL) begin 
                dataOut <= stack_mem[SP];
 
                stack_mem[SP] <= 4'b0000;
 
                SP <= SP + 1;
 
            end
        end

        
        if (SP == 4) begin
            EMPTY <= 1;
 
            FULL <= 0;
 
        end else if (SP == 0) begin
            EMPTY <= 0;
 
            FULL <= 1;
 
        end else begin
            EMPTY <= 0;
 
            FULL <= 0;
 
        end
    end
end

endmodule
