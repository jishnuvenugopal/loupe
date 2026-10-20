
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
            Y <= 3'b000;
            Y0 <= 1'b0;
            z <= 1'b0;
        end else begin
            case (y)
                3'b000: begin
                    if (x)
                        Y <= 3'b001;
                    else
                        Y <= 3'b000;
                end
                3'b001: begin
                    if (x)
                        Y <= 3'b100;
                    else
                        Y <= 3'b001;
                end
                3'b010: begin
                    if (x)
                        Y <= 3'b001;
                    else
                        Y <= 3'b010;
                end
                3'b011: begin
                    if (x)
                        Y <= 3'b010;
                    else
                        Y <= 3'b001;
                end
                3'b100: begin
                    if (x)
                        Y <= 3'b100;
                    else
                        Y <= 3'b011;
                end
                default: begin
                    Y <= 3'b000;
                end
            endcase
            Y0 <= Y[0];
            case (y)
                3'b000: begin
                    z <= 1'b0;
                end
                3'b001: begin
                    z <= 1'b0;
                end
                3'b010: begin
                    z <= 1'b0;
                end
                3'b011: begin
                    z <= 1'b1;
                end
                3'b100: begin
                    z <= 1'b1;
                end
                default: begin
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule
