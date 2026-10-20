
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
            
            if (digit0 == 4'b09) begin
                ena[0] <= 1'b1;
            end else begin
                ena[0] <= 1'b0;
            end
            
            if (digit1 == 4'b09) begin
                ena[1] <= 1'b1;
            end else begin
                ena[1] <= 1'b0;
            end
            
            if (digit2 == 4'b09) begin
                ena[2] <= 1'b1;
            end else begin
                ena[2] <= 1'b0;
            end
            
            if (digit3 == 4'b09) begin
                ena[3] <= 1'b1;
            end else begin
                ena[3] <= 1'b0;
            end

            
            digit0 <= (digit0 == 4'b09) ? 4'b0 : digit0 + 1;
            digit1 <= (digit1 == 4'b09) ? 4'b0 : digit1 + 1;
            digit2 <= (digit2 == 4'b09) ? 4'b0 : digit2 + 1;
            digit3 <= (digit3 == 4'b09) ? 4'b0 : digit3 + 1;

            
            q <= {digit3, digit2, digit1, digit0};
        end
    end

endmodule
