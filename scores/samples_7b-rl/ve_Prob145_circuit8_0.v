
module TopModule (
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);
    always @(posedge clock) begin
        p <= a;
        q <= p;
    end
endmodule
