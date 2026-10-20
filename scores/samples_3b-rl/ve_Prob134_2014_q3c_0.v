
module TopModule (
    input        clk,
    input        x,
    input [2:0]  y,
    output       Y0,
    output       z
);

    
    reg [2:0] y_next;
    reg Y0_next;
    reg z_next;

    
    always @(*) begin
        case (y)
            3'b000: begin
                if (x == 1'b0)
                    y_next = 3'b001;
                else
                    y_next = 3'b001;
                if (x == 1'b0)
                    Y0_next = 1'b0;
                else
                    Y0_next = 1'b0;
                if (x == 1'b0)
                    z_next = 1'b0;
                else
                    z_next = 1'b1;
            end
            3'b001: begin
                if (x == 1'b0)
                    y_next = 3'b010;
                else
                    y_next = 3'b100;
                if (x == 1'b0)
                    Y0_next = 1'b0;
                else
                    Y0_next = 1'b0;
                if (x == 1'b0)
                    z_next = 1'b0;
                else
                    z_next = 1'b1;
            end
            3'b010: begin
                if (x == 1'b0)
                    y_next = 3'b001;
                else
                    y_next = 3'b001;
                if (x == 1'b0)
                    Y0_next = 1'b0;
                else
                    Y0_next = 1'b0;
                if (x == 1'b0)
                    z_next = 1'b0;
                else
                    z_next = 1'b1;
            end
            3'b011: begin
                if (x == 1'b0)
                    y_next = 3'b001;
                else
                    y_next = 3'b010;
                if (x == 1'b0)
                    Y0_next = 1'b0;
                else
                    Y0_next = 1'b1;
                if (x == 1'b0)
                    z_next = 1'b0;
                else
                    z_next = 1'b1;
            end
            3'b100: begin
                if (x == 1'b0)
                    y_next = 3'b011;
                else
                    y_next = 3'b100;
                if (x == 1'b0)
                    Y0_next = 1'b0;
                else
                    Y0_next = 1'b1;
                if (x == 1'b0)
                    z_next = 1'b0;
                else
                    z_next = 1'b1;
            end
            default: begin
                y_next = 3'b000;
                Y0_next = 1'b0;
                z_next = 1'b0;
            end
        endcase
    end

    
    assign Y0 = Y0_next;
    assign z = z_next;

    
    reg [2:0] y_reg;
    always @(posedge clk) begin
        y_reg <= y_next;
    end

endmodule
