
module TopModule (
    input [99:0] a,
    input [99:0] b,
    input sel,
    output [99:0] out
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= 100'b0;
 
        end else begin
            if (sel == 0) begin
                out <= a;
 
            end else begin
                out <= b;
 
            end
        end
    end

endmodule
