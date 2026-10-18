`timescale 1ns / 1ps
// Reset while FULL: the spec says reset empties the stack, so FULL should drop.
module tb_resetfull;
  reg [3:0] dataIn; reg RW, EN, Rst, Clk; wire [3:0] dataOut; wire EMPTY, FULL;
  LIFObuffer uut(.dataIn(dataIn), .dataOut(dataOut), .RW(RW), .EN(EN), .Rst(Rst), .EMPTY(EMPTY), .FULL(FULL), .Clk(Clk));
  always #10 Clk = ~Clk;
  task step(input en, input rst, input rw, input [3:0] d);
    begin @(negedge Clk); EN = en; Rst = rst; RW = rw; dataIn = d; @(posedge Clk); #1; end
  endtask
  initial begin
    Clk = 0; EN = 0; Rst = 1; RW = 0; dataIn = 0;
    step(1,1,0,0); $display("after first reset : FULL=%b EMPTY=%b", FULL, EMPTY);
    step(1,0,0,1); step(1,0,0,2); step(1,0,0,3); step(1,0,0,4);
    $display("after 4 pushes    : FULL=%b EMPTY=%b", FULL, EMPTY);
    step(1,1,0,0); $display("after reset (full): FULL=%b EMPTY=%b", FULL, EMPTY);
    $finish;
  end
endmodule
