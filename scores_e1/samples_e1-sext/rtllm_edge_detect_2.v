
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    reg [1:0] state;
    reg prev_a;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00;
            prev_a <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            prev_a <= a;
            case (state)
                2'b00: begin
                    if (a == 1'b1) begin
                        state <= 2'b01;
                        rise <= 1'b1;
                        down <= 1'b0;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (a == 1'b0) begin
                        state <= 2'b10;
                        rise <= 1'b0;
                        down <= 1'b1;
                    end else begin
                        state <= 2'b01;
                    end
                end
                2'b10: begin
                    if (a == 1'b1) begin
                        state <= 2'b11;
                        rise <= 1'b0;
                        down <= 1'b0;
                    end else begin
                        state <= 2'b10;
                    end
                end
                2'b11: begin
                    if (a == 1'b0) begin
                        state <= 2'b00;
                        rise <= 1'b0;
                        down <= 1'b1;
                    end else begin
                        state <= 2'b11;
                    end
                end
            endcase
        end
    end

endmodule
