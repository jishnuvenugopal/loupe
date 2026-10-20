
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

    
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
        .wclk(wclk),
        .rclk(rclk),
        .wenc(wenc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .renc(renc),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    
    reg [WIDTH-1:0] waddr_bin;
    reg [WIDTH-1:0] wptr;
    reg [WIDTH-1:0] wptr_buff;

    always @(posedge wclk or posedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else begin
            waddr_bin <= waddr_bin + winc;
            wptr <= waddr_bin;
            wptr_buff <= wptr;
        end
    end

    
    reg [WIDTH-1:0] raddr_bin;
    reg [WIDTH-1:0] rptr;
    reg [WIDTH-1:0] rptr_buff;

    always @(posedge rclk or posedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else begin
            raddr_bin <= raddr_bin + rinc;
            rptr <= raddr_bin;
            rptr_buff <= rptr;
        end
    end

    
    reg [WIDTH-1:0] wptr_gray;
    reg [WIDTH-1:0] rptr_gray;

    always @(*) begin
        wptr_gray = wptr;
        rptr_gray = rptr;
        for (int i = WIDTH-1;
 i > 0;
 i--) begin
            wptr_gray[i] = wptr_gray[i] ^ wptr_gray[i-1];
            rptr_gray[i] = rptr_gray[i] ^ rptr_gray[i-1];
        end
    end

    
    always @(*) begin
        wfull = (wptr_gray == ~rptr_gray[WIDTH-1:2] & rptr_gray[1:0] == 4'b0000);
        rempty = (wptr_gray == rptr_gray);
    end

    
    reg [WIDTH-1:0] raddr_syn;

    always @(posedge rclk) begin
        raddr_syn <= raddr_bin;
    end

    
    reg [WIDTH-1:0] waddr_syn;

    always @(posedge wclk) begin
        waddr_syn <= waddr_bin;
    end

endmodule


module dual_port_RAM (
    input wire wclk,
    input wire rclk,
    input wire wenc,
    input wire [WIDTH-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire renc,
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

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
