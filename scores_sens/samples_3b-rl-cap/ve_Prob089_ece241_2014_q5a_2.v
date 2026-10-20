
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

always @(posedge clk or posedge areset) begin
    if (areset)
        z <= 1'b0;
    else begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            z <= z ^ x;
            z <= ~z;
        end
    end
end

endmodule
