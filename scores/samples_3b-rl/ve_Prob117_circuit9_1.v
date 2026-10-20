
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b1) begin
        if (q == 3'd7) begin
            q <= 3'd0;
        end else begin
            q <= q + 1;
        end
    end else begin
        
    end
    if (a == 1'b0) begin
        if (q == 3'd7) begin
            q <= 3'd0;
        end else begin
            q <= q + 1;
        end
    end else begin
        
    end
end

endmodule
