
module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg [3:0] dataOut,
    output reg EMPTY,
    output reg FULL
);

    
    localparam BUFFER_SIZE = 4;

    
    reg [3:0] stack_mem [BUFFER_SIZE-1:0];

    
    reg [1:0] SP;

    
    
    always @(posedge Clk) begin
        if (Rst) begin
            
            SP <= 2'b00;
            for (integer i = 0;
 i < BUFFER_SIZE;
 i = i + 1) begin
                stack_mem[i] <= 4'b0000;
            end
        end else if (EN) begin
            if (RW == 0) begin
                
                if (SP != BUFFER_SIZE-1) begin
                    
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 2'b01;
                end
            end else begin
                
                if (SP != 2'b00) begin
                    
                    dataOut <= stack_mem[SP-1];
                    stack_mem[SP-1] <= 4'b0000;
                    SP <= SP - 2'b01;
                end
            end
        end
    end

    
    assign EMPTY = (SP == 2'b00);

    
    assign FULL = (SP == BUFFER_SIZE-1);

endmodule
