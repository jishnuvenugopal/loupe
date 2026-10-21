
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] subtraction_result;
    assign subtraction_result = A - B;

    
    reg [3:0] carry;
    assign carry = subtraction_result[3];

    
    always @(posedge clock) begin
        if (carry == 1) begin
            A_less <= 1;
            A_greater <= 0;
            A_equal <= 0;
        end else if (subtraction_result == 0) begin
            A_less <= 0;
            A_greater <= 0;
            A_equal <= 1;
        end else begin
            A_less <= 0;
            A_greater <= 1;
            A_equal <= 0;
        end
    end

endmodule
