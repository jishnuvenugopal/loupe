
module TopModule (
    input clk,
    input rst,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    reg [2:0] Y;

    always @(posedge clk) begin
        if (rst) begin
            y <= 3'b000;
        end else begin
            case (y)
                3'b000: begin
                    if (x == 1'b0) begin
                        Y <= 3'b000;
                    end else begin
                        Y <= 3'b001;
                    end
                end
                3'b001: begin
                    if (x == 1'b0) begin
                        Y <= 3'b001;
                    end else begin
                        Y <= 3'b100;
                    end
                end
                3'b010: begin
                    if (x == 1'b0) begin
                        Y <= 3'b010;
                    end else begin
                        Y <= 3'b001;
                    end
                end
                3'b011: begin
                    if (x == 1'b0) begin
                        Y <= 3'b001;
                    end else begin
                        Y <= 3'b010;
                    end
                end
                3'b100: begin
                    if (x == 1'b0) begin
                        Y <= 3'b011;
                    end else begin
                        Y <= 3'b100;
                    end
                end
                default: begin
                    Y <= 3'b000;
                end
            endcase
        end
    end

    always @(*) begin
        Y0 = Y[0];
        if (Y == 3'b010 || Y == 3'b100) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end

endmodule
