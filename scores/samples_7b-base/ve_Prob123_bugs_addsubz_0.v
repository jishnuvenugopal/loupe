
module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        casex (do_sub)
            2'b00: out = a + b;
            2'b01: out = a - b;
            default: out = 8'bX;
        endcase

        result_is_zero = (out == 8'b0);
    end

endmodule
