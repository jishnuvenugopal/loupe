
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    assign result = A - B;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            overflow <= 0;
        end else begin
            if ((A[63] == 1 && B[63] == 0 && result[63] == 1) ||
                (A[63] == 0 && B[63] == 1 && result[63] == 0)) begin
                overflow <= 1;
            end else begin
                overflow <= 0;
            end
        end
    end

endmodule
