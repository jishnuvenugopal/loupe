
module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg [3:0] dataOut,
    output reg EMPTY,
    output reg FULL
);

    reg [3:0] stack_mem [3:0];
    reg [1:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
            for (int i = 0;
 i < 4;
 i = i + 1) begin
                stack_mem[i] <= 4'b0000;
            end
        end else if (EN) begin
            if (RW == 0) begin
                if (SP != 2'b00) begin
                    SP <= SP - 2'b01;
                    stack_mem[SP] <= dataIn;
                end
            end else begin
                if (SP != 2'b11) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0000;
                    SP <= SP + 2'b01;
                end
            end
            if (SP == 2'b00) begin
                EMPTY <= 1'b1;
                FULL <= 1'b0;
            end else if (SP == 2'b11) begin
                EMPTY <= 1'b0;
                FULL <= 1'b1;
            end else begin
                EMPTY <= 1'b0;
                FULL <= 1'b0;
            end
        end
    end

endmodule
