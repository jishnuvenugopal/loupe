
module adder_subtractor_zero_flag (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] zero;
    assign zero = (a + b) == 0;

    always @(*) begin
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase
        result_is_zero = zero;
    end

endmodule
