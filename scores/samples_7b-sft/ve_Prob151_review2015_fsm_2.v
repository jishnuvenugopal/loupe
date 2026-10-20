
module TopModule (
  input clk,
  input reset,
  input data,
  input done_counting,
  input ack,
  output shift_ena,
  output counting,
  output done
);

  
  localparam [1:0] IDLE      = 2'b00;
  localparam [1:0] SHIFT_ENA = 2'b01;
  localparam [1:0] COUNTING  = 2'b10;
  localparam [1:0] DONE      = 2'b11;

  reg [1:0] state, next_state;
  reg [3:0] pattern_reg;
  
  reg [1:0] counter;
      

  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_reg <= 4'b0;
      counter <= 2'b0;
    end else begin
      state <= next_state;
      
      if (state == IDLE)
        pattern_reg <= {pattern_reg[2:0], data};
      
      if (state == SHIFT_ENA)
        counter <= counter + 1;
    end
  end

  
  always @(*) begin
    case (state)
      IDLE: 
        next_state = (pattern_reg == 4'b1101) ? SHIFT_ENA : IDLE;
      SHIFT_ENA: 
        next_state = (counter == 2'b11) ? COUNTING : SHIFT_ENA;
      COUNTING: 
        next_state = done_counting ? DONE : COUNTING;
      DONE: 
        next_state = ack ? IDLE : DONE;
      default: 
        next_state = IDLE;
    endcase
  end

  
  assign shift_ena = (state == SHIFT_ENA);
  assign counting  = (state == COUNTING);
  assign done      = (state == DONE);

endmodule
