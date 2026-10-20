
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


dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) dual_port_ram_inst (
    .wclk(wclk),
    .rclk(rclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);


reg [WIDTH-1:0] waddr_bin;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] wptr_buff;

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else begin
        waddr_bin <= waddr_bin + winc;
        wptr <= waddr_bin;
        wptr_buff <= wptr;
    end
end


reg [WIDTH-1:0] raddr_bin;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] rptr_buff;

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rptr_buff <= 0;
    end else begin
        raddr_bin <= raddr_bin + rinc;
        rptr <= raddr_bin;
        rptr_buff <= rptr;
    end
end


reg [WIDTH-1:0] wptr_gray;
reg [WIDTH-1:0] rptr_gray;

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_gray <= 0;
    end else begin
        wptr_gray <= wptr ^ (wptr >> 1);
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        rptr_gray <= 0;
    end else begin
        rptr_gray <= rptr ^ (rptr >> 1);
    end
end


always @(posedge wclk or posedge rclk or posedge wrstn or posedge rrstn) begin
    if (~wrstn || ~rrstn) begin
        wfull <= 0;
        rempty <= 0;
    end else begin
        wfull <= (wptr_gray == ~rptr_gray);
        rempty <= (wptr_gray == rptr_gray);
    end
end


always @(posedge wclk or posedge rclk or posedge wrstn or posedge rrstn) begin
    if (~wrstn || ~rrstn) begin
        waddr <= 0;
        raddr <= 0;
    end else begin
        waddr <= wptr_buff;
        raddr <= rptr_buff;
    end
end


reg wen;
reg ren;

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wen <= 0;
    end else begin
        wen <= ~wfull;
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        ren <= 0;
    end else begin
        ren <= ~rempty;
    end
end

endmodule


module dual_port_RAM (
    input wire wclk,
    input wire rclk,
    input wire wenc,
    input wire [WIDTH-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire renc,
    output reg [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk or posedge wenc) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk or posedge renc) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
