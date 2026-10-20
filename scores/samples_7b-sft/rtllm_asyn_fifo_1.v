
module dual_port_RAM #(
  parameter WIDTH = 8,
  parameter DEPTH = 16
) (
  input wclk,
  input wenc,
  input [$clog2(DEPTH)-1:0] waddr,
  input [WIDTH-1:0] wdata,
  input rclk,
  input renc,
  input [$clog2(DEPTH)-1:0] raddr,
  output reg [WIDTH-1:0] rdata
);

  reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

  
  always @(posedge wclk) begin
    if (wenc) begin
      RAM_MEM[waddr] <= wdata;
    end
  end

  
  always @(posedge rclk) begin
    if (renc) begin
      rdata <= RAM_MEM[raddr];
    end
  end

endmodule

module asyn_fifo #(
  parameter WIDTH = 8,
  parameter DEPTH = 16
) (
  input wclk,
  input rclk,
  input wrstn,
  input rrstn,
  input winc,
  input rinc,
  input [WIDTH-1:0] wdata,
  output rempty,
  output wfull,
  output [WIDTH-1:0] rdata
);

  
  reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
  wire [3:0] wptr_gray, rptr_gray;
  wire [3:0] wptr_gray_sync1, wptr_gray_sync2;
  wire [3:0] rptr_gray_sync1, rptr_gray_sync2;

  
  assign wptr_gray = (waddr_bin >> 1) ^ waddr_bin;
  assign rptr_gray = (raddr_bin >> 1) ^ raddr_bin;

  
  always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
      rptr_gray_sync1 <= 4'b0;
      rptr_gray_sync2 <= 4'b0;
    end else begin
      rptr_gray_sync1 <= rptr_gray;
      rptr_gray_sync2 <= rptr_gray_sync1;
    end
  end

  
  always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
      wptr_gray_sync1 <= 4'b0;
      wptr_gray_sync2 <= 4'b0;
    end else begin
      wptr_gray_sync1 <= wptr_gray;
      wptr_gray_sync2 <= wptr_gray_sync1;
    end
  end

  
  assign rempty = (rptr_gray == wptr_gray_sync2);
  assign wfull = (wptr_gray == {~rptr_gray_sync2[3], ~rptr_gray_sync2[2], rptr_gray_sync2[1:0]});

  
  reg wenc;
  always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
      waddr_bin <= 0;
    end else begin
      if (winc && !wfull) begin
        waddr_bin <= waddr_bin + 1;
      end
    end
  end

  
  reg renc;
  always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
      raddr_bin <= 0;
    end else begin
      if (rinc && !rempty) begin
        raddr_bin <= raddr_bin + 1;
      end
    end
  end

  
  wire [$clog2(DEPTH)-1:0] waddr = waddr_bin;
  wire [$clog2(DEPTH)-1:0] raddr = raddr_bin;

  
  assign wenc = winc && !wfull;
  assign renc = rinc && !rempty;

  
  dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
  );

endmodule
