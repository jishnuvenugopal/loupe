
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rise <= 0;
        down <= 0;
    end else begin
        if (a && !prev_a) begin
            rise <= 1;
            down <= 0;
        end else if (!a && prev_a) begin
            rise <= 0;
            down <= 1;
        end else begin
            rise <= 0;
            down <= 0;
        end
        prev_a <= a;
    end
end

reg prev_a;

endmodule
