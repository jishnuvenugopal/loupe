
module TopModule (
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

    
    reg p_prev;

    
    always @(posedge clock) begin
        p_prev <= p;
 
        q <= a & p_prev;
 
    end

    
    always @(posedge clock) begin
        p <= ~a;
 
    end

endmodule
