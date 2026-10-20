
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

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
            stack_mem <= 4'b0000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (EN) begin
            if (SP == 2'b00) begin
                
                FULL <= 1'b1;
                EMPTY <= 1'b0;
            end else if (SP == 2'b11) begin
                
                FULL <= 1'b0;
                EMPTY <= 1'b1;
            end else begin
                if (!RW) begin
                    
                    if (SP != 2'b00) begin
                        stack_mem[SP-1] <= dataIn;
                        SP <= SP - 1;
                        FULL <= 1'b0;
                        EMPTY <= 1'b0;
                    end
                end else begin
                    
                    if (SP != 2'b11) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0000;
                        SP <= SP + 1;
                        FULL <= 1'b0;
                        EMPTY <= 1'b0;
                    end
                end
            end
        end
    end

endmodule
