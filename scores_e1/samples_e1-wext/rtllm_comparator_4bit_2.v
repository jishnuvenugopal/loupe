
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] result;
    assign result = A - B;

    
    always @(*) begin
        if (result < 0) begin
            A_less = 1'b1;
            A_greater = 1'b0;
            A_equal = 1'b0;
        end else if (result == 0) begin
            A_less = 1'b0;
            A_greater = 1'b0;
            A_equal = 1'b1;
        end else begin
            A_less = 1'b0;
            A_greater = 1'b1;
            A_equal = 1'b0;
        end
    end

endmodule
