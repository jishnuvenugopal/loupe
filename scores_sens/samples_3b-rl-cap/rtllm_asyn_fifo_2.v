
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

    wire wen, ren;

    
    assign wen = wenc;

    
    assign ren = renc;

    
    dual_port_RAM u_dpram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [3:0] wptr;
    reg [3:0] wptr_buff;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            waddr_bin <= 0;
        else
            waddr_bin <= waddr_bin + 1;
    end

    
    assign wptr[3] = waddr_bin[3];
    assign wptr[2] = waddr_bin[3] ^ waddr_bin[2];
    assign wptr[1] = waddr_bin[2] ^ waddr_bin[1];
    assign wptr[0] = waddr_bin[1] ^ waddr_bin[0];

    
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr_buff <= 4'b0000;
        else
            wptr_buff <= wptr;
    end

    
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [3:0] rptr;
    reg [3:0] rptr_buff;

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            raddr_bin <= 0;
        else
            raddr_bin <= raddr_bin + 1;
    end

    
    assign rptr[3] = raddr_bin[3];
    assign rptr[2] = raddr_bin[3] ^ raddr_bin[2];
    assign rptr[1] = raddr_bin[2] ^ raddr_bin[1];
    assign rptr[0] = raddr_bin[1] ^ raddr_bin[0];

    
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr_buff <= 4'b0000;
        else
            rptr_buff <= rptr;
    end

    
    assign wfull = (wptr == ~({rptr[3], rptr[3], rptr[3], rptr[0]}));
    assign rempty = (wptr == rptr);

    
    

endmodule
