
module LIFObuffer(
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg [3:0] dataOut,
    output reg EMPTY,
    output reg FULL
);

    
    localparam STACK_SIZE = 4;

    
    reg [3:0] stack_mem [0:STACK_SIZE-1];

    
    reg [1:0] SP;

    
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 4'b11;
            for (int i = 0;
 i < STACK_SIZE;
 i++) begin
                stack_mem[i] <= 4'b0;
            end
        end
    end

    
    always @(posedge Clk) begin
        if (EN && !Rst && !RW && SP != 0) begin
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end
    end

    
    always @(posedge Clk) begin
        if (EN && !Rst && RW && SP != STACK_SIZE) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end

    
    always @(posedge Clk) begin
        if (Rst) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else begin
            EMPTY <= (SP == 4'b11);
            FULL <= (SP == 4'b00);
        end
    end

endmodule
