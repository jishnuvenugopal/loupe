
module TopModule (
    input  [6:0] y,  
    input       w,  
    output      Y1, 
    output      Y3  
);

    reg [5:0] state_reg;
  
    reg       y2_reg;
       
    reg       y4_reg;
       

    
    always @(y or w) begin
        case ({y[5:3], w})
            3'b000: begin y2_reg = 0;
 y4_reg = 1;
 end  
            3'b001: begin y2_reg = 0;
 y4_reg = 0;
 end  
            3'b010: begin y2_reg = 1;
 y4_reg = 0;
 end  
            3'b011: begin y2_reg = 1;
 y4_reg = 1;
 end  
            3'b100: begin y2_reg = 0;
 y4_reg = 1;
 end  
            3'b101: begin y2_reg = 1;
 y4_reg = 1;
 end  
        endcase
    end

    
    always @(state_reg or y2_reg or y4_reg) begin
        case (state_reg)
            6'b000001: begin
                Y1 = 0;
 Y3 = 1;
  
            end
            6'b000010: begin
                Y1 = 0;
 Y3 = 0;
  
            end
            6'b000100: begin
                Y1 = 1;
 Y3 = 0;
  
            end
            6'b001000: begin
                Y1 = 1;
 Y3 = 1;
  
            end
            6'b010000: begin
                Y1 = 0;
 Y3 = 1;
  
            end
            6'b100000: begin
                Y1 = 1;
 Y3 = 1;
  
            end
        endcase
    end

    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state_reg <= 6'b000001;
  
            y2_reg <= 0;
            y4_reg <= 0;
        end else begin
            state_reg <= {y5, y4, y3, y2, y1, y0};
  
            y2_reg <= y[1];
  
            y4_reg <= y[3];
  
        end
    end

endmodule
