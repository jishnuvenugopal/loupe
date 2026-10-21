
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] digit0;
    reg [3:0] digit1;
    reg [3:0] digit2;
    reg [3:0] digit3;

    
    reg [3:0] enable0;
    reg [3:0] enable1;
    reg [3:0] enable2;
    reg [3:0] enable3;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit0 <= 4'b0000;
            digit1 <= 4'b0000;
            digit2 <= 4'b0000;
            digit3 <= 4'b0000;
            enable0 <= 4'b0000;
            enable1 <= 4'b0000;
            enable2 <= 4'b0000;
            enable3 <= 4'b0000;
        end else begin
            digit0 <= digit0 + 1'b1;
            digit1 <= digit1 + 1'b1;
            digit2 <= digit2 + 1'b1;
            digit3 <= digit3 + 1'b1;
            enable0 <= enable0 + 1'b1;
            enable1 <= enable1 + 1'b1;
            enable2 <= enable2 + 1'b1;
            enable3 <= enable3 + 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (ena[0]) begin
            digit0 <= digit0 + 1'b1;
        end
        if (ena[1]) begin
            digit1 <= digit1 + 1'b1;
        end
        if (ena[2]) begin
            digit2 <= digit2 + 1'b1;
        end
        if (ena[3]) begin
            digit3 <= digit3 + 1'b1;
        end
    end

    
    assign q = {digit3, digit2, digit1, digit0};
    assign ena = {enable3, enable2, enable1, enable0};

endmodule
