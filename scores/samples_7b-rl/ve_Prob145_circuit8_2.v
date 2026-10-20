
module TopModule (input clock, a, output reg p, output reg q);
    
    always @(posedge clock) begin
        q <= a;
    end
    always @(negedge clock) begin
        p <= q;
    end
endmodule
