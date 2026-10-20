
module TopModule (x, y, Y0, z);
  input x, y;
  output Y0, z;

  reg [1:0] state, next_state;

  
  parameter STATE_000 = 2'b00, STATE_001 = 2'b01, STATE_010 = 2'b10, STATE_011 = 2'b11, STATE_100 = 2'b100;

  always @(*) begin
    case (state)
      STATE_000:
        if (x == 0) next_state = STATE_000;
        else next_state = STATE_001;
      STATE_001:
        if (x == 0) next_state = STATE_001;
        else next_state = STATE_100;
      STATE_010:
        if (x == 0) next_state = STATE_010;
        else next_state = STATE_001;
      STATE_011:
        if (x == 0) next_state = STATE_001;
        else next_state = STATE_010;
      STATE_100:
        if (x == 0) next_state = STATE_011;
        else next_state = STATE_100;
      default: next_state = STATE_000;
 
    endcase
  end

  assign Y0 = state[0];
  assign z = !state[2];
 

  
  reg clk, reset;
  initial begin
    clk = 0;
    reset = 1;
    state = STATE_000;
    #10 reset = 0;
  end

  always @(posedge clk or posedge reset) begin
    if (reset) state <= STATE_000;
    else state <= next_state;
  end
endmodule
