
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

    
    parameter BUFFER_SIZE = 4;
    parameter DATA_WIDTH = 4;

    
    reg [DATA_WIDTH-1] stack_mem [BUFFER_SIZE-1:0];
    reg [BUFFER_SIZE-1:0] SP;

    
    initial begin
        $display("Initializing buffer...");
        for (int i = 0;
 i < BUFFER_SIZE;
 i = i + 1) begin
            stack_mem[i] = 4'b0;
        end
        SP = BUFFER_SIZE;
        EMPTY = 1'b1;
        FULL = 1'b0;
    end

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                
                $display("Resetting buffer...");
                for (int i = 0;
 i < BUFFER_SIZE;
 i = i + 1) begin
                    stack_mem[i] = 4'b0;
                end
                SP = BUFFER_SIZE;
                EMPTY = 1'b1;
                FULL = 1'b0;
            end else begin
                
                if (!FULL && !EMPTY) begin
                    if (RW == 1'b0) begin
                        
                        if (SP != 0) begin
                            stack_mem[SP-1] = dataIn;
                            SP = SP - 1;
                            EMPTY = 1'b0;
                            if (SP == 1) begin
                                FULL = 1'b1;
                            end
                        end
                    end else begin
                        
                        if (SP != BUFFER_SIZE) begin
                            dataOut = stack_mem[SP];
                            stack_mem[SP] = 4'b0;
                            SP = SP + 1;
                            FULL = 1'b0;
                            if (SP == BUFFER_SIZE-1) begin
                                EMPTY = 1'b1;
                            end
                        end
                    end
                end
            end
        end
    end

endmodule
