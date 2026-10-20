
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

    
    reg [3:0] stack_mem [3:0];
    reg [1:0] SP;

    
    initial begin
        SP = 4'd0;
        for (int i = 0;
 i < 4;
 i = i + 1) begin
            stack_mem[i] = 4'd0;
        end
    end

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'd0;
            for (int i = 0;
 i < 4;
 i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (!RW) begin
                
                if (SP != 2'd0) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP - 2'd1;
                end
            end else begin
                
                if (SP != 2'd3) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 2'd1;
                end
            end
        end

        
        if (SP == 2'd0) begin
            EMPTY = 1'b1;
        end else begin
            EMPTY = 1'b0;
        end

        
        if (SP == 2'd3) begin
            FULL = 1'b1;
        end else begin
            FULL = 1'b0;
        end
    end

endmodule
