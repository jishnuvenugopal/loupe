
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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);


reg [3:0] waddr_bin, raddr_bin;
wire [3:0] wptr_gray, rptr_gray;
reg [3:0] wptr_gray_sync1, wptr_gray_sync2;
 
reg [3:0] rptr_gray_sync1, rptr_gray_sync2;
 
wire [3:0] wptr_gray_sync, rptr_gray_sync;


wire wen, ren;


dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata)
);


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 4'b0;
    end else if (wen) begin
        waddr_bin <= waddr_bin + 1;
    end
end


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 4'b0;
    end else if (ren) begin
        raddr_bin <= raddr_bin + 1;
    end
end


assign wptr_gray = waddr_bin ^ (waddr_bin >> 1);
assign rptr_gray = raddr_bin ^ (raddr_bin >> 1);


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_gray_sync1 <= 4'b0;
        wptr_gray_sync2 <= 4'b0;
    end else begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end
end
assign wptr_gray_sync = wptr_gray_sync2;


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_sync1 <= 4'b0;
        rptr_gray_sync2 <= 4'b0;
    end else begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end
end
assign rptr_gray_sync = rptr_gray_sync2;


assign wfull = (wptr_gray[3] != rptr_gray_sync[3]) && 
               (wptr_gray[2] != rptr_gray_sync[2]) && 
               (wptr_gray[1:0] == rptr_gray_sync[1:0]);
assign rempty = (rptr_gray == wptr_gray_sync);


assign wen = winc && !wfull;
assign ren = rinc && !rempty;

endmodule


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
