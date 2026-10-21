
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
            if (a == 1'b1) begin
                if (prev_a == 2'b00) begin
                    edge_count <= 2'b01;
                    rise <= 1'b1;
                end else if (prev_a == 2'b01) begin
                    edge_count <= 2'b10;
                    down <= 1'b1;
                end
            end else if (a == 1'b0) begin
                if (prev_a == 2'b01) begin
                    edge_count <= 2'b00;
                    rise <= 1'b0;
                end else if (prev_a == 2'b10) begin
                    edge_count <= 2'b11;
                    down <= 1'b0;
                end
            end
            prev_a <= a;
        end
    end

endmodule
