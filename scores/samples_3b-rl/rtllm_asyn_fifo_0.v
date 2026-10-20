
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
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            waddr_bin <= {DEPTH-1{1'b0}};
        else
            waddr_bin <= waddr;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            raddr_bin <= {DEPTH-1{1'b0}};
        else
            raddr_bin <= raddr;
    end

    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr_bin] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr_bin];
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

    wire wen;
    wire ren;

    dual_port_RAM u_dpram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    reg [3:0] wptr;
    reg [3:0] rptr;

    reg [3:0] wptr_buff;
    reg [3:0] rptr_buff;

    
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            waddr_bin <= {DEPTH-1{1'b0}};
        else
            waddr_bin <= waddr_bin + 1'b1;
    end

    
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            raddr_bin <= {DEPTH-1{1'b0}};
        else
            raddr_bin <= raddr_bin + 1'b1;
    end

    
    assign wptr = waddr_bin ^ (waddr_bin >> 1);

    
    assign rptr = raddr_bin ^ (raddr_bin >> 1);

    
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr_buff <= 4'b0000;
        else
            wptr_buff <= wptr;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr_buff <= 4'b0000;
        else
            rptr_buff <= rptr;
    end

    
    assign wfull = (wptr == ~rptr[3:1]);

    
    assign rempty = (wptr == rptr);

    
    assign wen = wenc;

    
    assign ren = renc;

    
    wire [$clog2(DEPTH)-1:0] ram_addr;
    assign ram_addr = wptr[3:0];

    
    assign u_dpram.wdata = wdata;

    
    assign rdata = u_dpram.rdata;

endmodule
