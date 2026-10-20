
module TopModule(input d, input ena, output q);
    reg q_reg;
  

    always @(d or ena) begin
        case (ena)
            1'b0: q_reg = q_reg;
  
            1'b1: q_reg = d;
      
        endcase
    end

    assign q = q_reg;
  
endmodule
