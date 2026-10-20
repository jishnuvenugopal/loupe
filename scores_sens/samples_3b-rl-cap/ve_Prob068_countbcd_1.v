
module TopModule (
    input clk,
    input reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

    
    reg [3:0] digit0, digit1, digit2, digit3;

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'b0;
            digit1 <= 4'b0;
            digit2 <= 4'b0;
            digit3 <= 4'b0;
            ena <= 4'b0;
            q <= 16'b0;
        end else begin
            
            if (digit0 == 4'b1001) ena[0] <= 1'b1;
            else ena[0] <= 1'b0;
            if (digit1 == 4'b1001) ena[1] <= 1'b1;
            else ena[1] <= 1'b0;
            if (digit2 == 4'b1001) ena[2] <= 1'b1;
            else ena[2] <= 1'b0;
            if (digit3 == 4'b1001) ena[3] <= 1'b1;
            else ena[3] <= 1'b0;

            
            if (digit0 == 4'b1001) digit0 <= 4'b0;
            else digit0 <= digit0 + 4'b1;

            if (digit1 == 4'b1001) digit1 <= 4'b0;
            else digit1 <= digit1 + 4'b1;

            if (digit2 == 4'b1001) digit2 <= 4'b0;
            else digit2 <= digit2 + 4'b1;

            if (digit3 == 4'b1001) digit3 <= 4'b0;
            else digit3 <= digit3 + 4'b1;

            
            q <= {digit3, digit2, digit1, digit0};
        end
    end

endmodule
