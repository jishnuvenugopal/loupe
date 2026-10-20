
module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase

        
        if (out == 0)
            result_is_zero = 1;
        else
            result_is_zero = 0;

        
        if (a != a_prev || b != b_prev) begin
            result_is_zero = 0;
        end

        
        a_prev = a;
        b_prev = b;
    end

    reg [7:0] a_prev;
    reg [7:0] b_prev;

endmodule
