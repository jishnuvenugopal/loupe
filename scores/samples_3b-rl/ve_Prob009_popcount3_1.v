
module TopModule (
    input [2:0] in,
    output reg [1:0] out
);

    wire [2:0] sum;
    assign sum = in[2] + in[1] + in[0];

    always @(*) begin
        out = sum[1:0];
    end

endmodule
