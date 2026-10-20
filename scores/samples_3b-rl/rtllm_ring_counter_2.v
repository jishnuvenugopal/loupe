
module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b0000_0001;
 
    end else begin
        if (out[7]) begin
            out <= {out[6:0], 1'b1};
 
        end else begin
            out <= {out[6:0], 1'b0};
 
        end
    end
end

endmodule
