
module TopModule(in, state, next_state, out);
  input in, state[3:0];
  output reg next_state[3:0], out;

  
  always @(*) begin
    case (state)
      4'b0001: begin
        next_state = (in == 1'b0) ? 4'b0010 : 4'b0010;
 
      end
      4'b0010: begin
        next_state = (in == 1'b0) ? 4'b0100 : 4'b0100;
 
      end
      4'b0100: begin
        next_state = (in == 1'b0) ? 4'b0001 : 4'b1000;
 
      end
      4'b1000: begin
        next_state = (in == 1'b0) ? 4'b0100 : 4'b0010;
 
      end
      default: next_state = 4'b0001;
 
    endcase
  end

  
  always @(*) begin
    case (state)
      4'b0001: out = 1'b0;
      4'b0010: out = 1'b0;
      4'b0100: out = 1'b0;
      4'b1000: out = 1'b1;
      default: out = 1'b0;
 
    endcase
  end
endmodule
