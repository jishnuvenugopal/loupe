
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [1:0] count;
    assign count = {1'b0, a + b + c + d};
 

    reg q_reg;
    always @(*) begin
        case (count)
            2'b01: q_reg = 1'b1;
 
            2'b10: q_reg = 1'b1;
 
            default: q_reg = 1'b0;
        endcase
    end

    assign q = q_reg;

endmodule
