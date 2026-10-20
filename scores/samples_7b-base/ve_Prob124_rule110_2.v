
module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

reg [511:0] shiftReg;

always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    shiftReg <= {q[0], q[511:0], q[511]};
 
    for (integer i = 0;
 i < 512;
 i = i + 1) begin
      case ({shiftReg[i+2], shiftReg[i+1], shiftReg[i]})
        3'b111: q[i] <= 1'b0;
        3'b110: q[i] <= 1'b1;
        3'b101: q[i] <= 1'b1;
        3'b100: q[i] <= 1'b0;
        3'b011: q[i] <= 1'b1;
        3'b010: q[i] <= 1'b1;
        3'b001: q[i] <= 1'b1;
        3'b000: q[i] <= 1'b0;
      endcase
    end
  end
end

endmodule
