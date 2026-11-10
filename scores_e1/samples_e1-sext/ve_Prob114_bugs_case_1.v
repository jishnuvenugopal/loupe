
module TopModule (
    input wire [7:0] code,  
    input wire valid,      
    output reg [3:0] out,   
    output reg valid_out    
);

always @(*) begin
    case (code)
        8'b00000000: out = 4'b0000;
 valid_out = 1'b1;
  
        8'b00000001: out = 4'b0001;
 valid_out = 1'b1;
  
        8'b00000010: out = 4'b0010;
 valid_out = 1'b1;
  
        8'b00000011: out = 4'b0011;
 valid_out = 1'b1;
  
        8'b00000100: out = 4'b0100;
 valid_out = 1'b1;
  
        8'b00000101: out = 4'b0101;
 valid_out = 1'b1;
  
        8'b00000110: out = 4'b0110;
 valid_out = 1'b1;
  
        8'b00000111: out = 4'b0111;
 valid_out = 1'b1;
  
        8'b00001000: out = 4'b1000;
 valid_out = 1'b1;
  
        8'b00001001: out = 4'b1001;
 valid_out = 1'b1;
  
        default: out = 4'b0000;
 valid_out = 1'b0;
  
    endcase
end

endmodule
