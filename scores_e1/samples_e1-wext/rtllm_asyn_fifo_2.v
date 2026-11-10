
module asyn_fifo (
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;


dual_port_ram dual_port_ram (
    .wclk(wclk),
    .rclk(rclk),
    .wen(wen),
    .ren(ren),
    .waddr(waddr),
    .wdata(wdata),
    .raddr(raddr),
    .rdata(rdata)
);


assign wfull = (waddr == ~rptr) && (waddr == ~rptr + 1);
assign rempty = (raddr == wptr) && (raddr == wptr + 1);


reg [WIDTH-1:0] wptr_sync;
reg [WIDTH-1:0] rptr_sync;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_sync <= 0;
        rptr_sync <= 0;
        wptr_buff <= 0;
        rptr_buff <= 0;
    end else begin
        wptr_sync <= waddr;
        rptr_sync <= raddr;
        wptr_buff <= wptr_sync;
        rptr_buff <= rptr_sync;
    end
end


reg [WIDTH-1:0] wptr_sync;
reg [WIDTH-1:0] rptr_sync;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wptr_sync <= 0;
        rptr_sync <= 0;
        wptr_buff <= 0;
        rptr_buff <= 0;
    end else begin
        wptr_sync <= waddr;
        rptr_sync <= raddr;
        wptr_buff <= wptr_sync;
        rptr_buff <= rptr_sync;
    end
end


assign waddr_bin = waddr;
assign raddr_bin = raddr;

assign wptr = wptr_sync;
assign rptr = rptr_sync;

assign wfull = (waddr == ~rptr) && (waddr == ~rptr + 1);
assign rempty = (raddr == wptr) && (raddr == wptr + 1);

endmodule

module dual_port_ram (
    input wire wclk,
    input wire rclk,
    input wire wen,
    input wire ren,
    input wire [WIDTH-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM[DEPTH-1:0][WIDTH-1:0];

always @(posedge wclk or posedge wen) begin
    if (wen) begin
        RAM_MEM[waddr][WIDTH-1:0] <= wdata;
    end
end

always @(posedge rclk or posedge ren) begin
    if (ren) begin
        rdata <= RAM_MEM[raddr][WIDTH-1:0];
    end
end

endmodule
