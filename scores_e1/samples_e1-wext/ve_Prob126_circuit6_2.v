
module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    always @(*) begin
        
        q = a[2] << 12 | a[1] << 8 | a[0] << 4 | a[0];
    end

endmodule
