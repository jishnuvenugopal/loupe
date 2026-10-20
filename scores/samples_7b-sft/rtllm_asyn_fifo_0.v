
module asyn_fifo #(
  parameter WIDTH = 8,
  parameter DEPTH = 16
) (
  input wire wclk,
  input wire wrstn,
  input wire winc,
  input wire [WIDTH-1:0] wdata,
  output wire wfull,
  input wire rclk,
  input wire rrstn,
  input wire rinc,
  output wire [WIDTH-1:0] rdata,
  output wire rempty
);

  
  reg [3:0] waddr_bin;
  wire [3:0] wptr;

  
  reg [3:0] raddr_bin;
  wire [3:0] rptr;

  
  reg [3:0] rptr_sync1, rptr_sync2;
  reg [3:0] wptr_sync1, wptr_sync2;

  wire [3:0] rptr_syn = rptr_sync2;
  wire [3:0] wptr_syn = wptr_sync2;

  
  assign rempty = (wptr == rptr_syn);
  assign wfull = (wptr == {~rptr_syn[3], ~rptr_syn[2], rptr_syn[1:0]});

  
  dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
  ) ram (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
  );

  
  wire wen;
  assign wen = winc && !wfull;

  always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
      waddr_bin <= 4'b0;
    end else begin
      if (wen) begin
        waddr_bin <= waddr_bin + 1;
      end
    end
  end

  assign wptr = waddr_bin ^ (waddr_bin >> 1);

  
  wire ren;
  assign ren = rinc && !rempty;

  always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
      raddr_bin <= 4'b0;
    end else begin
      if (ren) begin
        raddr_bin <= raddr_bin + 1;
      end
    end
  end

  assign rptr = raddr_bin ^ (raddr_bin >> 1);

  
  always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
      rptr_sync1 <= 4'b0;
      rptr_sync2 <= 4'b0;
    end else begin
      rptr_sync1 <= rptr;
      rptr_sync2 <= rptr_sync1;
    end
  end

  
  always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
      wptr_sync1 <= 4'b0;
      wptr_sync2 <= 4'b0;
    end else begin
      wptr_sync1 <= wptr;
      wptr_sync2 <= wptr_sync1;
    end
  end

  
  wire [2:0] waddr = waddr_bin[2:0];
  wire [2:0] raddr = raddr_bin[2:0];

endmodule


module dual_port_RAM #(
  parameter DEPTH = 16,
  parameter WIDTH = 8
) (
  input wire wclk,
  input wire wenc,
  input wire [$clog2(DEPTH)-1:0] waddr,
  input wire [WIDTH-1:0] wdata,
  input wire rclk,
  input wire renc,
  input wire [$clog2(DEPTH)-1:0] raddr,
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
