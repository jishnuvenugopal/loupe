module square_wave(input clk, input [7:0] freq, output reg wave_out);
  initial wave_out = 1'b0;   // never toggles
  always @(posedge clk) wave_out <= 1'b0;
endmodule
