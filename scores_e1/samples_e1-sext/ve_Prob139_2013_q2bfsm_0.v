
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [1:0] state;
    reg [2:0] count_x;
    reg [2:0] count_y;

    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= 2'b00;
            count_x <= 3'b000;
            count_y <= 3'b000;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                2'b00: begin
                    if (resetn) begin
                        state <= 2'b00;
                        count_x <= 3'b000;
                        count_y <= 3'b000;
                        f <= 0;
                        g <= 0;
                    end else begin
                        state <= 2'b01;
                        count_x <= 0;
                    end
                end
                2'b01: begin
                    if (resetn) begin
                        state <= 2'b00;
                        count_x <= 3'b000;
                        count_y <= 3'b000;
                        f <= 0;
                        g <= 0;
                    end else begin
                        count_x <= count_x + 1;
                        if (count_x == 3'b011) begin
                            state <= 2'b10;
                            count_x <= 0;
                        end
                    end
                end
                2'b10: begin
                    if (resetn) begin
                        state <= 2'b00;
                        count_x <= 3'b000;
                        count_y <= 3'b000;
                        f <= 0;
                        g <= 0;
                    end else begin
                        count_y <= count_y + 1;
                        if (count_y == 3'b011) begin
                            state <= 2'b11;
                            count_y <= 0;
                        end
                    end
                end
                2'b11: begin
                    if (resetn) begin
                        state <= 2'b00;
                        count_x <= 3'b000;
                        count_y <= 3'b000;
                        f <= 0;
                        g <= 0;
                    end else begin
                        g <= 1;
                    end
                end
            endcase
        end
    end

endmodule
