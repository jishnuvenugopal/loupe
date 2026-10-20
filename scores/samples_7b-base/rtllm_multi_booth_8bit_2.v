
module multi_booth_8bit (clk, reset, a, b, p, rdy);
  input clk, reset;
  input [7:0] a, b;
  output reg [15:0] p;
  output reg rdy;

  reg [15:0] multiplier, multiplicand;
  reg [4:0] ctr;
  reg [15:0] booth_encoded;
  reg [15:0] temp_p;

  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      multiplier <= {{8{a[7]}}, a};
      multiplicand <= {{8{b[7]}}, b};
      ctr <= 5'b00000;
      booth_encoded <= 16'b0000000000000000;
      temp_p <= 16'b0000000000000000;
      p <= 16'b0000000000000000;
      rdy <= 1'b0;
    end else begin
      if (ctr < 5'b10000) begin
        booth_encoded <= booth_encoded << 1;
        booth_encoded[0] <= multiplier[15];
        ctr <= ctr + 1;
      end else begin
        rdy <= 1'b1;
      end
    end
  end

  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      temp_p <= 16'b0000000000000000;
    end else begin
      if (booth_encoded[15] == booth_encoded[14] && booth_encoded[14] == 1'b1) begin
        temp_p <= temp_p + multiplicand;
      end else if (booth_encoded[15] == booth_encoded[14] && booth_encoded[14] == 1'b0) begin
        temp_p <= temp_p - multiplicand;
      end
    end
  end

  
  always @(*) begin
    p = temp_p;
  end
endmodule
