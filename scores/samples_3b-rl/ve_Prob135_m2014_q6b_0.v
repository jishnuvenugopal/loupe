
module TopModule (
    input        clk,
    input        rst,
    input [2:0]  y,
    input        w,
    output       Y1
);

    
    reg [2:0] y_reg;

    
    always @(*) begin
        case (y[2:0])
            3'b000: 
                if (w == 1'b0) y_reg[1] = 1'b0;
                else          y_reg[1] = w;
            3'b001: 
                if (w == 1'b0) y_reg[1] = 1'b0;
                else          y_reg[1] = w;
            3'b010: 
                if (w == 1'b0) y_reg[1] = 1'b0;
                else          y_reg[1] = w;
            3'b011: 
                if (w == 1'b0) y_reg[1] = 1'b0;
                else          y_reg[1] = w;
            3'b100: 
                if (w == 1'b0) y_reg[1] = 1'b0;
                else          y_reg[1] = w;
            3'b101: 
                if (w == 1'b0) y_reg[1] = 1'b0;
                else          y_reg[1] = w;
            default: y_reg[1] = 1'b0;
        endcase
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_reg <= 3'b000;
        end else begin
            y_reg <= y;
        end
    end

    
    assign Y1 = y_reg[1];

endmodule
