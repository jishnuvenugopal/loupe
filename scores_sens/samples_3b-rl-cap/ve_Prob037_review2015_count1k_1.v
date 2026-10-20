
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  [9:0] q
);

    
    reg [9:0] count;

    always @(posedge clk) begin
        if (reset) begin
            q   <= 10'd0;
            count <= 10'd0;
        end else begin
            if (count == 10'd999) begin
                q   <= 10'd0;
                count <= 10'd0;
            end else begin
                q   <= q + 1'b1;
                count <= count + 1'b1;
            end
        end
    end

endmodule
