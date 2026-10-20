
module TopModule(
    input wire a,
    input wire b,
    input wire sel_b1,
    input wire sel_b2,
    output wire out_assign,
    output wire out_procedural
);
    
    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    
    always @(*) begin
        if (sel_b1 && sel_b2) begin
            out_procedural = b;
        end else begin
            out_procedural = a;
        end
    end
endmodule
