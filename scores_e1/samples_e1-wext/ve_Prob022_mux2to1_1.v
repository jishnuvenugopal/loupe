
module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output reg out
);

    
    always @(sel) begin
        if (sel == 0) begin
            out <= a;
        end else begin
            out <= b;
        end
    end

endmodule
