
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
reg [WIDTH-1:0] wptr_syn;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] wptr_buff_prev;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_buff <= 0;
        wptr_buff_prev <= 0;
    end else begin
        wptr_buff <= wptr;
        wptr_buff_prev <= wptr_buff;
    end
end


reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] rptr_syn;
reg [WIDTH-1:0] rptr_buff;
reg [WIDTH-1:0] rptr_buff_prev;
always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        rptr_buff <= 0;
        rptr_buff_prev <= 0;
    end else begin
        rptr_buff <= rptr;
        rptr_buff_prev <= rptr_buff;
    end
end


reg [WIDTH-1:0] wptr_gray;
reg [WIDTH-1:0] rptr_gray;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_gray <= 0;
        rptr_gray <= 0;
    end else begin
        wptr_gray <= wptr_buff ^ (wptr_buff >> 1);
        rptr_gray <= rptr_buff ^ (rptr_buff >> 1);
    end
end


reg [WIDTH-1:0] wptr_buff_prev;
reg [WIDTH-1:0] rptr_buff_prev;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_buff_prev <= 0;
        rptr_buff_prev <= 0;
    end else begin
        wptr_buff_prev <= wptr_buff;
        rptr_buff_prev <= rptr_buff;
    end
end


reg [WIDTH-1:0] wptr_gray_prev;
reg [WIDTH-1:0] rptr_gray_prev;
always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr_gray_prev <= 0;
        rptr_gray_prev <= 0;
    end else begin
        wptr_gray_prev <= wptr_gray;
        rptr_gray_prev <= rptr_gray;
    end
end

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wfull <= 0;
        rempty <= 0;
    end else begin
        if (wptr_gray == ~rptr_gray_prev) begin
            wfull <= 1;
        end else begin
            wfull <= 0;
        end
        if (rptr_gray == ~wptr_gray_prev) begin
            rempty <= 1;
        end else begin
            rempty <= 0;
        end
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wptr_syn <= 0;
        rptr_syn <= 0;
    end else begin
        if (wptr_gray == ~rptr_gray_prev) begin
            wptr_syn <= 1;
        end else begin
            wptr_syn <= 0;
        end
        if (rptr_gray == ~wptr_gray_prev) begin
            rptr_syn <= 1;
        end else begin
            rptr_syn <= 0;
        end
    end
end

endmodule
