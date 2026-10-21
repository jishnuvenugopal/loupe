
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
    .wdata(wdata),
    .rdata(rdata),
    .waddr(waddr),
    .raddr(raddr),
    .ram_mem(RAM_MEM)
);


reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] wptr_syn;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_buff <= 0;
        wptr_syn <= 0;
    end else begin
        wptr_buff <= wptr;
        wptr_syn <= wptr_buff;
    end
end


reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] rptr_buff;
reg [WIDTH-1:0] rptr_syn;
always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        rptr_buff <= 0;
        rptr_syn <= 0;
    end else begin
        rptr_buff <= rptr;
        rptr_syn <= rptr_buff;
    end
end


reg [WIDTH-1:0] wptr_gray;
reg [WIDTH-1:0] rptr_gray;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_gray <= 0;
        rptr_gray <= 0;
    end else begin
        wptr_gray <= wptr ^ (wptr >> 1);
        rptr_gray <= rptr ^ (rptr >> 1);
    end
end


reg [WIDTH-1:0] wptr_bin;
reg [WIDTH-1:0] rptr_bin;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
        rptr_bin <= 0;
    end else begin
        wptr_bin <= {wptr_gray[WIDTH-1], wptr_gray[WIDTH-2], wptr_gray[WIDTH-3], wptr_gray[WIDTH-4]};
        rptr_bin <= {rptr_gray[WIDTH-1], rptr_gray[WIDTH-2], rptr_gray[WIDTH-3], rptr_gray[WIDTH-4]};
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wfull <= 0;
        rempty <= 0;
    end else begin
        if (wptr_bin == ~rptr_bin) begin
            wfull <= 1;
        end else begin
            wfull <= 0;
        end
        if (rptr == wptr) begin
            rempty <= 1;
        end else begin
            rempty <= 0;
        end
    end
end


reg [WIDTH-1:0] wptr_buff2;
reg [WIDTH-1:0] rptr_buff2;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_buff2 <= 0;
        rptr_buff2 <= 0;
    end else begin
        wptr_buff2 <= wptr_buff;
        rptr_buff2 <= rptr_buff;
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wptr_buff <= 0;
        rptr_buff <= 0;
    end else begin
        wptr_buff <= wptr_buff2;
        rptr_buff <= rptr_buff2;
    end
end


always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr <= 0;
    end else begin
        if (winc) begin
            wptr <= wptr + 1;
        end
    end
end


always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        rptr <= 0;
    end else begin
        if (rinc) begin
            rptr <= rptr + 1;
        end
    end
end


reg [WIDTH-1:0] RAM_MEM[DEPTH-1:0][WIDTH-1:0];

endmodule

module dual_port_ram (
    input wire wclk,
    input wire rclk,
    input wire wen,
    input wire ren,
    input wire wdata,
    input wire rdata,
    input wire waddr,
    input wire raddr,
    output reg [WIDTH-1:0] ram_mem[DEPTH-1:0][WIDTH-1:0]
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM[DEPTH-1:0][WIDTH-1:0];

always @(posedge wclk or posedge wen) begin
    if (wen) begin
        ram_mem[waddr][WIDTH-1:0] <= wdata;
    end
end

always @(posedge rclk or posedge ren) begin
    if (ren) begin
        rdata <= ram_mem[raddr][WIDTH-1:0];
    end
end

endmodule
