
module TopModule (
    input        clk,
    input        rst,
    input        x,
    input [2:0]  y,
    output       Y0,
    output       z
);

    
    reg [2:0] y_reg;
    reg [2:0] Y;

    
    always @(posedge clk) begin
        if (rst) begin
            y_reg <= 3'b000;
        end else begin
            case (y_reg)
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
                3'b101: begin
                    if (x)
                        Y <= 3'b100;
                    else
                        Y <= 3'b101;
                end
                3'b110: begin
                    if (x)
                        Y <= 3'b110;
                    else
                        Y <= 3'b101;
                end
                3'b111: begin
                    if (x)
                        Y <= 3'b110;
                    else
                        Y <= 3'b111;
                end
                default: Y <= 3'b000;
            endcase
            y_reg <= Y;
        end
    end

    
    assign Y0 = Y[0];
    assign z   = (y_reg == 3'b111) ? 1'b1 : 1'b0;

endmodule
