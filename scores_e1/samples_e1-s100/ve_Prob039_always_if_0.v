
module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);

always @(posedge clk) begin
    if (sel_b1 && sel_b2) begin
        out_assign = b;
        out_always = b;
    end else begin
        out_assign = a;
        out_always = a;
    end
end

endmodule
