
module dual_port_RAM (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    parameter DEPTH = 16;
    parameter WIDTH = 8;

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule

module asyn_fifo (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    parameter DEPTH = 16;
    parameter WIDTH = 8;

    reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    reg [3:0] wptr, rptr;
    reg [3:0] wptr_buff, rptr_buff;

    
    dual_port_RAM u_dpram (
        .wclk(wclk),
        .wenc(winc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    
    reg [3:0] waddr_gray;
    always @(*) begin
        waddr_gray = waddr_bin ^ (waddr_bin >> 1);
    end

    
    reg [3:0] raddr_gray;
    always @(*) begin
        raddr_gray = raddr_bin ^ (raddr_bin >> 1);
    end

    
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            waddr_bin <= 0;
        else
            waddr_bin <= waddr_bin + 1;
    end

    
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            raddr_bin <= 0;
        else
            raddr_bin <= raddr_bin + 1;
    end

    
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr_buff <= 0;
        else
            wptr_buff <= wptr;
    end

    
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr_buff <= 0;
        else
            rptr_buff <= rptr;
    end

    
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr <= 0;
        else
            wptr <= waddr_gray;
    end

    
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr <= 0;
        else
            rptr <= raddr_gray;
    end

    
    always @(*) begin
        wfull = (wptr == ~rptr);
    end

    
    always @(*) begin
        rempty = (rptr == wptr);
    end

    
    assign wen = wfull ? 1'b0 : winc;

    
    assign ren = rempty ? 1'b0 : rinc;

    
    reg [$clog2(DEPTH)-1:0] raddr_syn;
    always @(*) begin
        raddr_syn = rptr_buff;
    end

    
    reg [3:0] raddr_syn_gray;
    always @(*) begin
        raddr_syn_gray = raddr_syn ^ (raddr_syn >> 1);
    end

    
    assign raddr_bin = raddr_syn_gray;

endmodule
