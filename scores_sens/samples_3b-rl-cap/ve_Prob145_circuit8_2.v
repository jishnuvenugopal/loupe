
module TopModule (
    input  wire clock,
    input  wire a,
    output reg  p,
    output reg  q
);

    always @(posedge clock) begin
        if (a == 1'b0) begin
            p <= 1'b0;
            q <= 1'b0;
        end else begin
            p <= 1'b0;
            q <= 1'b1;
        end
    end

    
    initial begin
        p = 1'bx;
        q = 1'bx;
    end

endmodule
