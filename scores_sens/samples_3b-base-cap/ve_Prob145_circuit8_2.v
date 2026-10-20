
module TopModule (
    input wire clock,
    input wire a,
    output wire p,
    output wire q
);

    
    reg p_prev;

    
    assign p = ~a;
    assign q = a & p_prev;

    
    always @(posedge clock) begin
        p_prev <= p;
    end

endmodule
