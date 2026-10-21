
module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    
    always @(a, b) begin
        out_alwaysblock = a & b;
    end

    
    assign out_assign = out_alwaysblock;

endmodule
