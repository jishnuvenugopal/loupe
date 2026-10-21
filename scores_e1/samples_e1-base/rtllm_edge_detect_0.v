
module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg [1:0] edge_count;
    reg [1:0] prev_a;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_count <= 2'b00;
            prev_a <= 2'b00;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            if (a != prev_a) begin
                if (a == 1'b1) begin
                    edge_count <= edge_count + 2'b01;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    edge_count <= edge_count + 2'b10;
                    rise <= 1'b0;
                    down <= 1'b1;
                end
            end else begin
                edge_count <= edge_count;
                rise <= 1'b0;
                down <= 1'b0;
            end
            prev_a <= a;
        end
    end

endmodule
