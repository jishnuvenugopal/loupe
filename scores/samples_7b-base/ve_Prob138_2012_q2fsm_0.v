
module TopModule(
  input wire clk,
  input wire reset,
  input wire w,
  output wire z
);

  
  parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

  
  reg [2:0] current_state, next_state;

  
  always @(posedge clk or posedge reset) begin
    if (reset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  
  always @(*) begin
    next_state = current_state;
    case (current_state)
      A: begin
        if (w)
          next_state = B;
      end
      B: begin
        if (w)
          next_state = C;
        else
          next_state = D;
      end
      C: begin
        if (w)
          next_state = E;
        else
          next_state = D;
      end
      D: begin
        if (w)
          next_state = F;
        else
          next_state = A;
      end
      E: begin
        if (w)
          next_state = E;
        else
          next_state = D;
      end
      F: begin
        if (w)
          next_state = C;
        else
          next_state = D;
      end
    endcase
  end

  
  assign z = (current_state == A || current_state == D) ? 1'b0 : 1'b1;

endmodule
