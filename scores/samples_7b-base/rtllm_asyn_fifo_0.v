
module asyn_fifo (
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram_inst (
        .wclk(wclk),
        .wenc(winc && wrstn),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && rrstn),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    
    reg [$clog2(DEPTH):0] waddr_bin;
    reg [$clog2(DEPTH):0] waddr_gray;
    reg [$clog2(DEPTH):0] waddr_gray_pre;
    reg [$clog2(DEPTH)-1:0] wptr;

    
    reg [$clog2(DEPTH):0] raddr_bin;
    reg [$clog2(DEPTH):0] raddr_gray;
    reg [$clog2(DEPTH):0] raddr_gray_pre;
    reg [$clog2(DEPTH)-1:0] rptr_syn;

    
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_buff <= 0;
            waddr_bin <= 0;
            waddr_gray <= 0;
            waddr_gray_pre <= 0;
        end else begin
            wptr <= (wptr + 1) % DEPTH;
            wptr_buff <= wptr;
            waddr_bin <= wptr;
            waddr_gray <= (wptr[0] ^ wptr[1]) << 1 | (wptr[2] ^ wptr[1]) << 0 | wptr[3];
            waddr_gray_pre <= (wptr_gray << 1) | wptr[0];
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_syn <= 0;
            rptr_buff <= 0;
            raddr_bin <= 0;
            raddr_gray <= 0;
            raddr_gray_pre <= 0;
        end else begin
            rptr_syn <= (rptr_syn + 1) % DEPTH;
            rptr_buff <= rptr_syn;
            raddr_bin <= rptr_syn;
            raddr_gray <= (rptr_syn[0] ^ rptr_syn[1]) << 1 | (rptr_syn[2] ^ rptr_syn[1]) << 0 | rptr_syn[3];
            raddr_gray_pre <= (raddr_gray << 1) | raddr_syn[0];
        end
    end

    
    assign wfull = (wptr_gray[3] ^ wptr_gray[2]) & (wptr_gray[1] ^ wptr_gray[0]) & (wptr_gray[0] == rptr_gray[0]);
    assign rempty = (rptr_syn == wptr);

endmodule


module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input wire wclk,
    input wire wenc,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire rclk,
    input wire renc,
    input wire [$clog2(DEPTH)-1:0] raddr,
    output wire [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule
