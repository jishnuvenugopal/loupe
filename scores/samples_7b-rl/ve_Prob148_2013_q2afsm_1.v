
module TopModule (
  input clk,
  input resetn,
  input [2:0] r,
  output reg [2:0] g
);

  
  reg [1:0] state, next_state;

  parameter A = 2'b00,
            B = 2'b01,
            C = 2'b10,
            D = 2'b11;

  
  always @(posedge clk) begin
    if (!resetn)
      state <= A;
    else
      state <= next_state;
  end

  
  always @* begin
    case (state)
      A: begin
        if (r == 3'b000)
          next_state = A;
        else if (r[0])
          next_state = B;
        else if (r[1])
          next_state = C;
        else if (r[2])
          next_state = D;
        else
          next_state = A;
      end

      B: begin
        next_state = (r[0]) ? B : A;
      end

      C: begin
        next_state = (r[1]) ? C : A;
      end

      D: begin
        next_state = (r[2]) ? D : A;
      end

      default: next_state = A;
    endcase
  end

  
  always @* begin
    case (state)
      A: g = 3'b000;
      B: g = 3'b001;
      C: g = 3'b010;
      D: g = 3'b100;
      default: g = 3'b000;
    endcase
  end

endmodule
