
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


always @(posedge wclk) begin
    if (winc) begin
        wptr <= wptr + 1;
    end
end


always @(posedge rclk) begin
    if (rinc) begin
        rptr <= rptr + 1;
    end
end


always @(posedge wrstn) begin
    wptr <= 0;
end


always @(posedge rrstn) begin
    rptr <= 0;
end


always @(posedge wclk or posedge rclk or posedge wrstn or posedge rrstn) begin
    if (~wrstn) begin
        wfull <= 0;
        rempty <= 0;
    end else begin
        if (wptr == ~rptr_buff) begin
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

always @(posedge wclk or posedge rclk) begin
    if (wen) begin
        RAM_MEM[waddr][WIDTH-1:0] <= wdata;
    end
end

always @(posedge rclk) begin
    if (ren) begin
        rdata <= RAM_MEM[raddr][WIDTH-1:0];
    end
end

endmodule
