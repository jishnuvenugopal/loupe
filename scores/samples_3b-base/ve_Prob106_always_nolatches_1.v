
module TopModule (
    input  scancode,  
    output left,     
    output down,     
    output right,    
    output up        
);

    
    wire [15:0] last_two_bytes = scancode[15:8];

    
    always @(*) begin
        case (last_two_bytes)
            16'h6b: begin  
                left = 1'b1;
                down = 1'b0;
                right = 1'b0;
                up = 1'b0;
            end
            16'h72: begin  
                left = 1'b0;
                down = 1'b1;
                right = 1'b0;
                up = 1'b0;
            end
            16'h74: begin  
                left = 1'b0;
                down = 1'b0;
                right = 1'b1;
                up = 1'b0;
            end
            16'h75: begin  
                left = 1'b0;
                down = 1'b0;
                right = 1'b0;
                up = 1'b1;
            end
            default: begin  
                left = 1'b0;
                down = 1'b0;
                right = 1'b0;
                up = 1'b0;
            end
        endcase
    end

endmodule
