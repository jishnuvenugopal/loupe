
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    always @(a, b, c, d) begin
        if (a & b & c & d) begin
            out = 1'b1;
        end else if (a & b & c) begin
            out = 1'b0;
        end else if (a & b & d) begin
            out = 1'b0;
        end else if (a & c & d) begin
            out = 1'b0;
        end else if (b & c & d) begin
            out = 1'b0;
        end else if (a & b) begin
            out = 1'b0;
        end else if (a & c) begin
            out = 1'b0;
        end else if (a & d) begin
            out = 1'b0;
        end else if (b & c) begin
            out = 1'b0;
        end else if (b & d) begin
            out = 1'b0;
        end else if (c & d) begin
            out = 1'b0;
        end else begin
            out = 1'b1;
        end
    end

endmodule
