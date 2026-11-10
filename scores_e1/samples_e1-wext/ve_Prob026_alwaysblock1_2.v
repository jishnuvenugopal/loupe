
module TopModule (
    input a,
    input b,
    output reg out_assign,
    output reg out_alwaysblock
);

    
    assign out_assign = a & b;

    
    always @(a, b) begin
        out_alwaysblock = a & b;
    end

endmodule
