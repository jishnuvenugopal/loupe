
module TopModule (clk, load, ena, data, q);
  input clk, load, ena;
  input [1:0] ena;
  input [99:0] data;
  output reg [99:0] q;

  reg [99:0] shift_reg;
  reg load_reg;

  
  always @(posedge clk) begin
    load_reg <= load;
  end

  always @(posedge clk) begin
    if (load_reg) begin
      shift_reg <= data;
    end else if (ena == 2'b01) begin
      shift_reg <= {shift_reg[0], shift_reg[99:1]};
    end else if (ena == 2'b10) begin
      shift_reg <= {shift_reg[98:0], shift_reg[99]};
    end
  end

  
  assign q = shift_reg;

endmodule
