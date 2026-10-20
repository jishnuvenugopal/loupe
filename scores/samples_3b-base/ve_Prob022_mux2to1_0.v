
module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

    
    if (sel == 0) begin
        out = a;
    end else begin
        out = b;
    end

endmodule
