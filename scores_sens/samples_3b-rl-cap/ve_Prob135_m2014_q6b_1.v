
module TopModule (
    input  wire w,
    output wire Y1,
    input  wire [2:0] y
);

    
    reg [2:0] y_reg;

    
    always @(posedge w) begin
        case (y)
            3'b000: y_reg <= 3'b001;
 
            3'b001: y_reg <= 3'b001;
 
            3'b010: y_reg <= 3'b011;
 
            3'b011: y_reg <= 3'b010;
 
            3'b100: y_reg <= 3'b101;
 
            3'b101: y_reg <= 3'b100;
 
            3'b110: y_reg <= 3'b111;
 
            3'b111: y_reg <= 3'b001;
 
            default: y_reg <= 3'b000;
 
        endcase
    end

    
    assign Y1 = y_reg[1];

    
    assign y = y_reg;

endmodule
