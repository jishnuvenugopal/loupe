
module TopModule (
    input clk,
    input reset,
    output [3:0] ena,
    output [15:0] q
);
    reg [3:0] digit0, digit1, digit2, digit3;
    
    
    assign q = {digit3, digit2, digit1, digit0};
    
    
    wire en0 = (digit0 == 4'd9);
    wire en1 = (digit1 == 4'd9) && en0;
    wire en2 = (digit2 == 4'd9) && en1;
    wire en3 = (digit3 == 4'd9) && en2;
    
    assign ena = {en3, en2, en1, en0};
  
    
    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end
        else begin
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    if (digit2 == 4'd9) begin
                        digit2 <= 4'd0;
                        digit3 <= (digit3 == 4'd9) ? 4'd0 : digit3 + 4'd1;
                    end
                    else digit2 <= digit2 + 4'd1;
                end
                else digit1 <= digit1 + 4'd1;
            end
            else digit0 <= digit0 + 4'd1;
        end
    end
endmodule
