
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
    reg [$clog2(DEPTH)-1:0] wptr, rptr;
    reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
    reg [3:0] wptr_gray, rptr_gray;

    
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

    
    always @(*) begin
        wptr_gray = wptr;
        wptr_gray[0] = wptr[0];
        wptr_gray[1] = wptr[1] ^ wptr[0];
        wptr_gray[2] = wptr[2] ^ wptr[1];
        wptr_gray[3] = wptr[3] ^ wptr[2];
    end

    
    always @(*) begin
        rptr_gray = rptr;
        rptr_gray[0] = rptr[0];
        rptr_gray[1] = rptr[1] ^ rptr[0];
        rptr_gray[2] = rptr[2] ^ rptr[1];
        rptr_gray[3] = rptr[3] ^ rptr[2];
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

    
    always @(*) begin
        if (wptr_gray == ~rptr_gray)
            wfull = 1;
        else
            wfull = 0;

        if (rptr_gray == wptr_gray)
            rempty = 1;
        else
            rempty = 0;
    end

    
    assign wen = wfull ? 1'b0 : winc;

    
    assign ren = rempty ? 1'b0 : rinc;

    
    assign waddr = wptr_gray;
    assign raddr = rptr_gray;

endmodule
