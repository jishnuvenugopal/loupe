
module TopModule (
  input clk,
  input areset,
  input in,
  output out
);

  reg state;
 

  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 1;
 
    end else begin
      case (state)
        0: 
          state <= (in == 0) ? 1 : 0;
        1: 
          state <= (in == 0) ? 0 : 1;
        default: 
          state <= 1;
 
      endcase
    end
  end

  
  assign out = (~state);
 

endmodule
