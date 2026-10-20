
module comparator_3bit (
    input [2:0] A,  
    input [2:0] B,  
    output reg A_greater,  
    output reg A_equal,  
    output reg A_less   
);

    
    wire [2:0] AB = {A, B};

    
    always @(*) begin
        case (AB)
            3'b111: A_greater = 1'b1;
  
            3'b110: A_greater = 1'b1;
  
            3'b101: A_greater = 1'b1;
  
            3'b100: A_greater = 1'b1;
  
            3'b011: A_equal = 1'b1;
  
            3'b010: A_equal = 1'b1;
  
            3'b001: A_equal = 1'b1;
  
            3'b000: A_less = 1'b1;
   
            default: begin
                A_greater = 1'b0;
                A_equal = 1'b0;
                A_less = 1'b0;
            end
        endcase
    end

endmodule
