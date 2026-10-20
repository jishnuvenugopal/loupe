
module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    
    reg [2:0] y_reg;

    
    always @(*) begin
        case (y)
            3'b000: y_reg = w ? 3'b000 : 3'b001;
 
            3'b001: y_reg = w ? 3'b001 : 3'b010;
 
            3'b010: y_reg = w ? 3'b010 : 3'b011;
 
            3'b011: y_reg = w ? 3'b011 : 3'b100;
 
            3'b100: y_reg = w ? 3'b100 : 3'b101;
 
            3'b101: y_reg = w ? 3'b101 : 3'b010;
 
            default: y_reg = 3'b000;
        endcase
    end

    
    assign Y1 = y_reg[1];

    
    always @(posedge w) begin
        y_reg <= y_reg;
    end

endmodule
