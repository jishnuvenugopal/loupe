
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    reg [63:0] temp_result;
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            temp_result <= 64'b0;
            result <= 64'b0;
            overflow <= 0;
        end else begin
            temp_result <= A - B;
            result <= temp_result;
            
            if ((A[63] == 1 && B[63] == 0 && temp_result[63] == 1) ||
                (A[63] == 0 && B[63] == 1 && temp_result[63] == 0)) begin
                overflow <= 1;
            end else begin
                overflow <= 0;
            end
        end
    end

endmodule
