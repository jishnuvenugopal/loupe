
module asyn_fifo (
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata,
    output reg wfull,
    output reg rempty
);

parameter WIDTH = 8;
parameter DEPTH = 16;


dual_port_ram dual_port_ram (
    .wclk(wclk),
    .rclk(rclk),
    .wen(wen),
    .ren(ren),
    .waddr(waddr),
    .raddr(raddr),
    .wdata(wdata),
    .rdata(rdata)
);


reg [WIDTH-1:0] waddr_bin;
reg [WIDTH-1:0] raddr_bin;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] wptr_syn;
reg [WIDTH-1:0] rptr_syn;


reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;


reg [3:0] wptr_gray;
reg [3:0] rptr_gray;


reg wfull_gray;
reg rempty_gray;


always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        raddr_bin <= 0;
        wptr <= 0;
        rptr <= 0;
        wptr_syn <= 0;
        rptr_syn <= 0;
        wptr_buff <= 0;
        rptr_buff <= 0;
        wptr_gray <= 0;
        rptr_gray <= 0;
        wfull_gray <= 0;
        rempty_gray <= 0;
    end else begin
        waddr_bin <= waddr;
        raddr_bin <= raddr;
        wptr <= wptr + 1;
        rptr <= rptr + 1;
        wptr_syn <= wptr;
        rptr_syn <= rptr;
        wptr_buff <= wptr;
        rptr_buff <= rptr;
        wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
        rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
        wfull_gray <= (wptr_gray == (2**WIDTH - 1));
        rempty_gray <= (rptr_gray == wptr_gray);
    end
end


always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wptr_buff <= 0;
        rptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
        rptr_buff <= rptr;
    end
end


always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wfull_gray <= 0;
        rempty_gray <= 0;
    end else begin
        wfull_gray <= (wptr_gray == (2**WIDTH - 1));
        rempty_gray <= (rptr_gray == wptr_gray);
    end
end


assign wfull = wfull_gray;
assign rempty = rempty_gray;
assign rdata = dual_port_ram.rdata;
endmodule

module dual_port_ram (
    input wire wclk,
    input wire rclk,
    input wire wen,
    input wire ren,
    input wire waddr,
    input wire raddr,
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
