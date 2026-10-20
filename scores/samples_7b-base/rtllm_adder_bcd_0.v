
module adder_bcd (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output reg [3:0] Sum,
    output wire Cout
);

    reg [4:0] temp_sum;

    assign temp_sum = A + B + Cin;

    assign Sum = temp_sum[3:0];

    assign Cout = temp_sum[4];

    always @(*) begin
        if (temp_sum[3:0] > 9)
            Sum = temp_sum[3:0] - 6;
        else
            Sum = temp_sum[3:0];
    end

endmodule
