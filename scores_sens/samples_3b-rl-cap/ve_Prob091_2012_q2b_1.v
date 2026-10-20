
module TopModule (
    input  wire [5:0] y,    
    input  wire       w,    
    output wire        Y1,  
    output wire        Y3   
);

    
    reg [5:0] y_reg;

    
    assign Y1 = y_reg[1];
    assign Y3 = y_reg[3];

    always @(*) begin
        
        case (y)
            6'b000001: begin 
                if (w)
                    y_reg = 6'b000010;
 
                else
                    y_reg = 6'b000001;
 
            end
            6'b000010: begin 
                if (w)
                    y_reg = 6'b000100;
 
                else
                    y_reg = 6'b000010;
 
            end
            6'b000100: begin 
                if (w)
                    y_reg = 6'b001000;
 
                else
                    y_reg = 6'b000100;
 
            end
            6'b001000: begin 
                if (w)
                    y_reg = 6'b010000;
 
                else
                    y_reg = 6'b001000;
 
            end
            6'b010000: begin 
                if (w)
                    y_reg = 6'b010000;
 
                else
                    y_reg = 6'b001000;
 
            end
            6'b100000: begin 
                if (w)
                    y_reg = 6'b000100;
 
                else
                    y_reg = 6'b001000;
 
            end
            default: y_reg = 6'b000001;
 
        endcase
    end

endmodule
