
module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);

always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_assign = b;
    end else begin
        out_assign = a;
    end
end

always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule
