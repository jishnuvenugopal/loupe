
module TopModule (
    input        clk,
    input        rst,
    input  [6:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    
    reg [5:0] y_reg;
    reg Y2, Y4;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_reg <= 6'b000001;
        end else begin
            case (y_reg)
                6'b000001: begin 
                    if (y[1] == 1'b0) begin
                        y_reg <= 6'b000010;
                    end else begin
                        y_reg <= 6'b000001;
                    end
                end
                6'b000010: begin 
                    if (y[1] == 1'b0) begin
                        y_reg <= 6'b000100;
                    end else begin
                        y_reg <= 6'b000010;
                    end
                end
                6'b000100: begin 
                    if (y[1] == 1'b0) begin
                        y_reg <= 6'b001000;
                    end else begin
                        y_reg <= 6'b000100;
                    end
                end
                6'b001000: begin 
                    if (y[1] == 1'b0) begin
                        y_reg <= 6'b010000;
                    end else begin
                        y_reg <= 6'b001000;
                    end
                end
                6'b010000: begin 
                    if (y[1] == 1'b0) begin
                        y_reg <= 6'b100000;
                    end else begin
                        y_reg <= 6'b010000;
                    end
                end
                6'b100000: begin 
                    if (y[1] == 1'b0) begin
                        y_reg <= 6'b000001;
                    end else begin
                        y_reg <= 6'b100000;
                    end
                end
                default: begin
                    y_reg <= 6'b000001;
                end
            endcase
        end
    end

    
    assign Y1 = y_reg[0];
    assign Y3 = w;

    
    
    
    
    

endmodule
