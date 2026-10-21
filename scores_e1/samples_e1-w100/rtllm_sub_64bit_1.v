
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    reg [63:0] temp;
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            temp <= 64'b0;
            result <= 64'b0;
            overflow <= 0;
        end else begin
            temp <= A - B;
            result <= temp;
            
            if ((A >= 0 && B < 0 && temp < 0) || (A < 0 && B >= 0 && temp > 0)) begin
                overflow <= 1;
            end else begin
                overflow <= 0;
            end
        end
    end

endmodule
