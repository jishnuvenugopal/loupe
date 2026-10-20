
module TopModule(input [7:0] code, output reg [3:0] out, output reg valid);
  reg [31:0] code_valid_mapping;
  
  
  initial begin
    code_valid_mapping = 32'h00000000;
  
    code_valid_mapping[0*8 +: 8] = 8'h45;
  
    code_valid_mapping[1*8 +: 8] = 8'h16;
  
    code_valid_mapping[2*8 +: 8] = 8'h1E;
  
    code_valid_mapping[3*8 +: 8] = 8'h26;
  
    code_valid_mapping[4*8 +: 8] = 8'h25;
  
    code_valid_mapping[5*8 +: 8] = 8'h2E;
  
    code_valid_mapping[6*8 +: 8] = 8'h36;
  
    code_valid_mapping[7*8 +: 8] = 8'h3D;
  
    code_valid_mapping[8*8 +: 8] = 8'h3E;
  
    code_valid_mapping[9*8 +: 8] = 8'h46;
  
  end
  
  always @(code) begin
    case (code)
      8'h45: begin out = 4'b0000;
 valid = 1'b1;
 end
      8'h16: begin out = 4'b0001;
 valid = 1'b1;
 end
      8'h1E: begin out = 4'b0010;
 valid = 1'b1;
 end
      8'h26: begin out = 4'b0011;
 valid = 1'b1;
 end
      8'h25: begin out = 4'b0100;
 valid = 1'b1;
 end
      8'h2E: begin out = 4'b0101;
 valid = 1'b1;
 end
      8'h36: begin out = 4'b0110;
 valid = 1'b1;
 end
      8'h3D: begin out = 4'b0111;
 valid = 1'b1;
 end
      8'h3E: begin out = 4'b1000;
 valid = 1'b1;
 end
      8'h46: begin out = 4'b1001;
 valid = 1'b1;
 end
      default: begin out = 4'b0000;
 valid = 1'b0;
 end
    endcase
  end
endmodule
