
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        rise <= 0;
        down <= 0;
    end else begin
        case (state)
            2'b00: begin
                if (a == 1'b0) begin
                    state <= 2'b01;
                    rise <= 0;
                    down <= 0;
                end else begin
                    state <= 2'b00;
                    rise <= 0;
                    down <= 0;
                end
            end
            2'b01: begin
                if (a == 1'b1) begin
                    state <= 2'b10;
                    rise <= 1;
                    down <= 0;
                end else begin
                    state <= 2'b01;
                    rise <= 0;
                    down <= 0;
                end
            end
            2'b10: begin
                if (a == 1'b0) begin
                    state <= 2'b00;
                    rise <= 0;
                    down <= 1;
                end else begin
                    state <= 2'b10;
                    rise <= 0;
                    down <= 1;
                end
            end
            default: begin
                state <= 2'b00;
                rise <= 0;
                down <= 0;
            end
        endcase
    end
end

assign rise = state == 2'b01;
assign down = state == 2'b10;

endmodule
