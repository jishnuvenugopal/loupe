
module TopModule (
    input [2:0] in,
    output reg [1:0] out
);

    wire [2:0] count;
    assign count = in[0] + in[1] + in[2];

    always @(*) begin
        if (count > 3)
            out = 2'b11;
        else
            out = count[1:0];
    end

endmodule
