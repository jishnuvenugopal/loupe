 
module TopModule (
    input  d,
    input  ena,
    output q
);
    reg q;

    always @(ena or d) begin
        if (ena)
            q <= d;
    end

endmodule 
