
module TopModule(in, state, next_state, out);
  input in, state;
  output reg next_state, out;

  
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

  always @(*) begin
    case (state)
      A: begin
        if (in == 0) begin
          next_state = B;
        end else begin
          next_state = A;
        end
        out = 0;
      end
      B: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
        out = 0;
      end
      C: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = D;
        end
        out = 0;
      end
      D: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
        out = 1;
      end
      default: begin
        next_state = A;
        out = 0;
      end
    endcase
  end
endmodule
