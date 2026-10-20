
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

    
    reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

    
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
        wptr = waddr_bin;
        wptr[3] = waddr_bin[3] ^ waddr_bin[2];
        wptr[2] = waddr_bin[2] ^ waddr_bin[1];
        wptr[1] = waddr_bin[1] ^ waddr_bin[0];
        wptr[0] = waddr_bin[0];
    end

    
    always @(*) begin
        rptr = raddr_bin;
        rptr[3] = raddr_bin[3] ^ raddr_bin[2];
        rptr[2] = raddr_bin[2] ^ raddr_bin[1];
        rptr[1] = raddr_bin[1] ^ raddr_bin[0];
        rptr[0] = raddr_bin[0];
    end

    
    always @(*) begin
        wfull = (wptr == ~rptr[3:0]);
    end

    
    always @(*) begin
        rempty = (wptr == rptr);
    end

    
    reg [$clog2(DEPTH)-1:0] raddr_syn;
    always @(*) begin
        if (rempty)
            raddr_syn = 0;
        else
            raddr_syn = rptr_buff;
    end

    
    wire wen;
    wire renc;

    always @(posedge wclk) begin
        if (winc)
            wen = 1;
        else
            wen = 0;
    end

    always @(posedge rclk) begin
        if (rinc)
            renc = 1;
        else
            renc = 0;
    end

    
    dual_port_RAM u_dpram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr_syn),
        .rdata(rdata)
    );

endmodule
