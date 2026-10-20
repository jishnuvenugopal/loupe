
module TopModule(input c, input d, output reg [3:0] mux_in);
  reg [1:0] ab;

  
  assign ab = {c, d};

  
  reg [1:0] mux_1out;
  assign mux_1out = (ab == 2'b00) ? 2'b0001 : (ab == 2'b10) ? 2'b0001 : 2'b0000;

  
  reg [1:0] mux_2out;
  assign mux_2out = (ab == 2'b01) ? 2'b0000 : (ab == 2'b11) ? 2'b0011 : 2'b0000;

  
  assign mux_in = (ab == 2'b00 || ab == 2'b10) ? mux_1out : mux_2out;
endmodule
