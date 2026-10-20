
module TopModule (
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);
    always @(negedge clock or posedge a) begin
        if (a) begin
            p <= 1;
            q <= 1;
        end
        else if (!clock) begin
            p <= 0;
            q <= 0;
        end
    end
endmodule
