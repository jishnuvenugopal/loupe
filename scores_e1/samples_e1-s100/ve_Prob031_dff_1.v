
module TopModule (
    input clk,
    input d,
    output reg q
);

    
    always @(posedge clk) begin
        if (d) begin
            q <= 1'b1;
        end else begin
            q <= 1'b0;
        end
    end

endmodule
