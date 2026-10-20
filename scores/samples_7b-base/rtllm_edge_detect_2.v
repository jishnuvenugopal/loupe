
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    reg a_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 0;
            rise <= 0;
            down <= 0;
        end else begin
            a_reg <= a;

            if (a_reg == 0 && a == 1) begin
                rise <= 1;
                down <= 0;
            end else if (a_reg == 1 && a == 0) begin
                rise <= 0;
                down <= 1;
            end else begin
                rise <= 0;
                down <= 0;
            end
        end
    end

endmodule
