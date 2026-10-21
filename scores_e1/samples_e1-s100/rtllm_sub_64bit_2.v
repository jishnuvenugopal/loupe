
module sub_64bit (
    input wire [63:0] A,
    input wire [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    
    reg [63:0] borrow;
    reg [63:0] temp;

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            result <= 64'b0;
            borrow <= 1'b0;
            overflow <= 1'b0;
        end else begin
            
            temp = A - B;

            
            if (A[63] && !B[63] && temp[63]) begin
                borrow <= 1'b1;
            end else begin
                borrow <= 1'b0;
            end

            
            if (A[63] && B[63] && temp[63]) begin
                overflow <= 1'b1;
            end else begin
                overflow <= 1'b0;
            end

            
            result <= temp;
        end
    end

endmodule
