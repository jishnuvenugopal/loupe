
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] digit1, digit2, digit3, digit4;
    reg [3:0] flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit1 <= 4'b0000;
            digit2 <= 4'b0000;
            digit3 <= 4'b0000;
            digit4 <= 4'b0000;
            flag <= 4'b0000;
        end else begin
            if (flag[0]) begin
                digit1 <= digit1 + 1'b1;
                flag <= flag[1:0];
            end else begin
                flag <= flag[1:0];
            end
            if (flag[1]) begin
                digit2 <= digit2 + 1'b1;
                flag <= flag[2:0];
            end else begin
                flag <= flag[2:0];
            end
            if (flag[2]) begin
                digit3 <= digit3 + 1'b1;
                flag <= flag[3:0];
            end else begin
                flag <= flag[3:0];
            end
            if (flag[3]) begin
                digit4 <= digit4 + 1'b1;
                flag <= 4'b0000;
            end else begin
                flag <= flag[3:0];
            end
        end
    end

    
    assign ena = {digit1[3], digit2[3], digit3[3], digit4[3]};

endmodule
