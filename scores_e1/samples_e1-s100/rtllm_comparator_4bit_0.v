
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        A_greater <= 1'b0;
        A_equal <= 1'b0;
        A_less <= 1'b0;
    end else begin
        reg [3:0] result;
        reg [3:0] borrow;

        
        result = A - B;

        
        borrow = result[3];

        
        if (borrow) begin
            A_less <= 1'b1;
        end else if (result != 0) begin
            A_greater <= 1'b1;
        end else begin
            A_equal <= 1'b1;
        end
    end
end

endmodule
