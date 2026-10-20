
module TopModule (
    input        clk,
    input        x,
    input [2:0]  y,
    output       Y0,
    output       z
);

    
    reg [2:0] y_reg;
    reg [2:0] Y_reg;
    reg       z_reg;

    
    assign Y0 = Y_reg[0];
    assign z  = z_reg;

    always @(posedge clk) begin
        
        y_reg <= y;

        
        case (y_reg)
            3'b000: begin
                if (x == 1'b0)
                    Y_reg <= 3'b000;
                else
                    Y_reg <= 3'b001;
                if (x == 1'b0)
                    z_reg <= 1'b0;
                else
                    z_reg <= 1'b0;
            end
            3'b001: begin
                if (x == 1'b0)
                    Y_reg <= 3'b001;
                else
                    Y_reg <= 3'b100;
                if (x == 1'b0)
                    z_reg <= 1'b0;
                else
                    z_reg <= 1'b0;
            end
            3'b010: begin
                if (x == 1'b0)
                    Y_reg <= 3'b010;
                else
                    Y_reg <= 3'b001;
                if (x == 1'b0)
                    z_reg <= 1'b0;
                else
                    z_reg <= 1'b0;
            end
            3'b011: begin
                if (x == 1'b0)
                    Y_reg <= 3'b001;
                else
                    Y_reg <= 3'b010;
                if (x == 1'b0)
                    z_reg <= 1'b0;
                else
                    z_reg <= 1'b1;
            end
            3'b100: begin
                if (x == 1'b0)
                    Y_reg <= 3'b011;
                else
                    Y_reg <= 3'b100;
                if (x == 1'b0)
                    z_reg <= 1'b1;
                else
                    z_reg <= 1'b1;
            end
            default: begin
                Y_reg <= 3'b000;
                z_reg <= 1'b0;
            end
        endcase
    end

endmodule
