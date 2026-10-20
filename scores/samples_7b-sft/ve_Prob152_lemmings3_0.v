
module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

  parameter W_LEFT = 3'b000;
  parameter W_RIGHT = 3'b001;
  parameter FALL_LEFT = 3'b010;
  parameter FALL_RIGHT = 3'b011;
  parameter DIG_LEFT = 3'b100;
  parameter DIG_RIGHT = 3'b101;

  reg [2:0] current_state, next_state;

  always @(posedge clk or posedge areset) begin
    if (areset) current_state <= W_LEFT;
    else current_state <= next_state;
  end

  always @(*) begin
    case (current_state)
      W_LEFT: begin
        if (~ground) next_state = FALL_LEFT;
        else if (dig && ground) next_state = DIG_LEFT;
        else if (bump_left || bump_right) next_state = W_RIGHT;
        else next_state = W_LEFT;
      end
      W_RIGHT: begin
        if (~ground) next_state = FALL_RIGHT;
        else if (dig && ground) next_state = DIG_RIGHT;
        else if (bump_left || bump_right) next_state = W_LEFT;
        else next_state = W_RIGHT;
      end
      FALL_LEFT: next_state = ground ? W_LEFT : FALL_LEFT;
      FALL_RIGHT: next_state = ground ? W_RIGHT : FALL_RIGHT;
      DIG_LEFT: begin
        if (~ground) next_state = FALL_LEFT;
        else if (~dig) next_state = W_LEFT;
        else next_state = DIG_LEFT;
      end
      DIG_RIGHT: begin
        if (~ground) next_state = FALL_RIGHT;
        else if (~dig) next_state = W_RIGHT;
        else next_state = DIG_RIGHT;
      end
      default: next_state = W_LEFT;
    endcase
  end

  assign walk_left = (current_state == W_LEFT) || (current_state == DIG_LEFT);
  assign walk_right = (current_state == W_RIGHT) || (current_state == DIG_RIGHT);
  assign aaah = (current_state == FALL_LEFT) || (current_state == FALL_RIGHT);
  assign digging = (current_state == DIG_LEFT) || (current_state == DIG_RIGHT);

endmodule
