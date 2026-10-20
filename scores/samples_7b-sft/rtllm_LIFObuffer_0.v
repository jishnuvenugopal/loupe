
module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [2:0] SP;

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4;
        stack_mem[0] <= 0;
        stack_mem[1] <= 0;
        stack_mem[2] <= 0;
        stack_mem[3] <= 0;
        dataOut <= 0;
    end else if (EN) begin
        if (!RW) begin 
            if (!FULL) begin
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
        end else begin 
            if (!EMPTY) begin
                dataOut <= stack_mem[SP-1];
                stack_mem[SP-1] <= 0;
                SP <= SP + 1;
            end
        end
    end
end

endmodule
