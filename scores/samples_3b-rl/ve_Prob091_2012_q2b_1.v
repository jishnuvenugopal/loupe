
module TopModule (
    input  wire [5:0] y,   
    input  wire       w,   
    output wire       Y1,  
    output wire       Y3   
);

    
    assign Y1 = y[1];
    assign Y3 = y[3];

    
    reg [5:0] y_reg;

    always @(*) begin
        
        case (y)
            6'b000001: y_reg = w ? 6'b000010 : 6'b000001;
 
            6'b000010: y_reg = w ? 6'b000100 : 6'b000010;
 
            6'b000100: y_reg = w ? 6'b001000 : 6'b000100;
 
            6'b001000: y_reg = w ? 6'b010000 : 6'b001000;
 
            6'b010000: y_reg = w ? 6'b100000 : 6'b010000;
 
            6'b100000: y_reg = w ? 6'b000100 : 6'b010000;
 
            default:   y_reg = 6'b000001;
               
        endcase
    end

    
    always @(*) begin
        y = y_reg;
    end

endmodule
