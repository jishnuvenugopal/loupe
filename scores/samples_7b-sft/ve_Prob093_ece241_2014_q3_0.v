
module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  
  mux2to1 mux0(.a(1'b0), .b(1'b0), .sel(1'b0), .out(mux_in[0]));

  
  mux2to1 mux1(.a(d), .b(~d), .sel(c), .out(mux_in[1]));

  
  mux2to1 mux2(.a(d), .b(1'b0), .sel(c), .out(mux_in[2]));

  
  mux2to1 mux3(.a(~d), .b(1'b0), .sel(c), .out(mux_in[3]));
endmodule


module mux2to1(a, b, sel, out);
  input a, b, sel;
  output out;
  assign out = sel ? b : a;
endmodule


module mux4to1(a, b, sel, out);
  input a, b;
  input [1:0] sel;
  output out;
  assign out = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b11) ? b :
               a;
 
endmodule
