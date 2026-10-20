
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
            SP <= 4'b00;
 
            for (int i = 0;
 i < 4;
 i++) begin
                stack_mem[i] <= 4'b0000;
 
            end
        end
    end

    
    always @(posedge Clk) begin
        if (EN) begin
            if (RW == 1'b0) begin 
                if (SP != 4'b111) begin 
                    stack_mem[SP] <= dataIn;
 
                    SP <= SP + 1'b1;
 
                    FULL <= 1'b0;
 
                end
            end else begin 
                if (SP != 4'b000) begin 
                    dataOut <= stack_mem[SP];
 
                    stack_mem[SP] <= 4'b0000;
 
                    SP <= SP - 1'b1;
 
                    EMPTY <= 1'b0;
 
                end
            end
        end
    end

    
    always @(*) begin
        if (SP == 4'b000) begin
            EMPTY <= 1'b1;
 
        end else begin
            EMPTY <= 1'b0;
 
        end

        if (SP == 4'b111) begin
            FULL <= 1'b1;
 
        end else begin
            FULL <= 1'b0;
 
        end
    end

endmodule
