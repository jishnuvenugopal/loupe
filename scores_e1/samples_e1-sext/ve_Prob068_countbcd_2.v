
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] digit1, digit2, digit3, digit4;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit1 <= 4'b0000;
            digit2 <= 4'b0000;
            digit3 <= 4'b0000;
            digit4 <= 4'b0000;
        end else begin
            if (ena[0]) begin
                digit1 <= digit1 + 1'b1;
            end
            if (ena[1]) begin
                digit2 <= digit2 + 1'b1;
            end
            if (ena[2]) begin
                digit3 <= digit3 + 1'b1;
            end
            if (ena[3]) begin
                digit4 <= digit4 + 1'b1;
            end
        end
    end

    
    assign ena[0] = (digit1[3] == 1'b1);
    assign ena[1] = (digit2[3] == 1'b1);
    assign ena[2] = (digit3[3] == 1'b1);

    
    assign q[3:0] = digit1;
    assign q[7:4] = digit2;
    assign q[11:8] = digit3;
    assign q[15:12] = digit4;

endmodule
