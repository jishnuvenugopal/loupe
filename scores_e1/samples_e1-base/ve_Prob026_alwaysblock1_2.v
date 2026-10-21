
module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    
    always @(*) begin
        out_alwaysblock = a & b;
    end

    
    assign out_assign = a & b;

endmodule
