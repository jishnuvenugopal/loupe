
module TopModule (
    input wire [5:0] y,  
    input wire w,       
    output reg Y1,      
    output reg Y3       
);


always @(posedge w or posedge y) begin
    case (y)
        6'b000001: begin
            state <= 6'b000010;
  
            Y1 <= 1'b1;
         
            Y3 <= 1'b0;
         
        end
        6'b000010: begin
            state <= 6'b000100;
  
            Y1 <= 1'b0;
         
            Y3 <= 1'b1;
         
        end
        6'b000100: begin
            state <= 6'b001000;
  
            Y1 <= 1'b1;
         
            Y3 <= 1'b0;
         
        end
        6'b001000: begin
            state <= 6'b010000;
  
            Y1 <= 1'b0;
         
            Y3 <= 1'b1;
         
        end
        6'b010000: begin
            state <= 6'b100000;
  
            Y1 <= 1'b1;
         
            Y3 <= 1'b0;
         
        end
        default: begin
            state <= 6'b000001;
  
            Y1 <= 1'b1;
         
            Y3 <= 1'b0;
         
        end
    endcase
end


reg [5:0] state;

endmodule
