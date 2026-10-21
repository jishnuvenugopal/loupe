
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

reg [1:0] edge_state;
reg [1:0] last_edge_state;

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        edge_state <= 2'b00;
        last_edge_state <= 2'b00;
        rise <= 0;
        down <= 0;
    end else begin
        case (edge_state)
            2'b00: begin
                if (a == 1'b1) begin
                    edge_state <= 2'b01;
                    last_edge_state <= 2'b00;
                    rise <= 1;
                    down <= 0;
                end else begin
                    edge_state <= 2'b00;
                    last_edge_state <= 2'b00;
                    rise <= 0;
                    down <= 0;
                end
            end
            2'b01: begin
                if (a == 1'b0) begin
                    edge_state <= 2'b10;
                    last_edge_state <= 2'b01;
                    rise <= 0;
                    down <= 1;
                end else begin
                    edge_state <= 2'b01;
                    last_edge_state <= 2'b01;
                    rise <= 0;
                    down <= 0;
                end
            end
            2'b10: begin
                if (a == 1'b1) begin
                    edge_state <= 2'b11;
                    last_edge_state <= 2'b10;
                    rise <= 0;
                    down <= 0;
                end else begin
                    edge_state <= 2'b10;
                    last_edge_state <= 2'b10;
                    rise <= 0;
                    down <= 0;
                end
            end
            2'b11: begin
                if (a == 1'b0) begin
                    edge_state <= 2'b00;
                    last_edge_state <= 2'b11;
                    rise <= 0;
                    down <= 1;
                end else begin
                    edge_state <= 2'b11;
                    last_edge_state <= 2'b11;
                    rise <= 0;
                    down <= 0;
                end
            end
        endcase
    end
end

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        rise <= 0;
        down <= 0;
    end else begin
        if (edge_state == 2'b01) begin
            rise <= 1;
        end else if (edge_state == 2'b10) begin
            down <= 1;
        end else begin
            rise <= 0;
            down <= 0;
        end
    end
end

endmodule
