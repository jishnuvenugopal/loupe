
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    reg [0:0] prev_a;

    always @(posedge clk) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
            prev_a <= 1'b0;
        end else begin
            if (a == 1'b1 && prev_a == 1'b0) begin
                
                rise <= 1'b1;
                down <= 1'b0;
            end else if (a == 1'b0 && prev_a == 1'b1) begin
                
                rise <= 1'b0;
                down <= 1'b1;
            end else begin
                rise <= 1'b0;
                down <= 1'b0;
            end
            prev_a <= a;
        end
    end

endmodule
