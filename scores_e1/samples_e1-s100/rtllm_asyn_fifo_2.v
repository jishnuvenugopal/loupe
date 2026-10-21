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
        .wdata(wdata),
        .rdata(rdata),
        .waddr(waddr),
        .raddr(raddr),
        .ram_mem(RAM_MEM)
    );

    
    reg [WIDTH-1:0] waddr_bin, raddr_bin;
    reg [WIDTH-1:0] wptr, rptr, wptr_syn, rptr_syn;
    reg [WIDTH-1:0] wptr_buff, rptr_buff;

    
    reg [3:0] wptr_gray, rptr_gray;
    reg [3:0] wptr_gray_prev, rptr_gray_prev;

    
    reg [3:0] wptr_gray_mask, rptr_gray_mask;
    reg [3:0] wptr_gray_mask_prev, rptr_gray_mask_prev;

    
    always @(posedge wclk or posedge wrstn) begin
        if (~wrstn) begin
            wptr <= 0;
            rptr <= 0;
            wptr_gray <= 0;
            rptr_gray <= 0;
            wptr_gray_prev <= 0;
            rptr_gray_prev <= 0;
            wptr_gray_mask <= 0;
            rptr_gray_mask <= 0;
            wptr_gray_mask_prev <= 0;
            rptr_gray_mask_prev <= 0;
        end else begin
            wptr <= wptr + winc;
            rptr <= rptr + rinc;
            wptr_gray <= wptr ^ (wptr >> 1);
            rptr_gray <= rptr ^ (rptr >> 1);
            wptr_gray_prev <= wptr_gray;
            rptr_gray_prev <= rptr_gray;
            wptr_gray_mask <= wptr_gray ^ (wptr_gray >> 1);
            rptr_gray_mask <= rptr_gray ^ (rptr_gray >> 1);
            wptr_gray_mask_prev <= wptr_gray_mask;
            rptr_gray_mask_prev <= rptr_gray_mask;
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

    
    always @(posedge wclk or posedge wrstn) begin
        if (~wrstn) begin
            wfull <= 0;
            rempty <= 0;
        end else begin
            wfull <= (wptr_gray == 0) & (wptr_gray_prev == 0);
            rempty <= (rptr == wptr);
        end
    end

    
    assign waddr = waddr_bin;
    assign ren = 1'b1;
    assign wen = 1'b1;
    assign wdata = wdata;
    assign rdata = rdata;
    assign ram_mem = RAM_MEM;

endmodule