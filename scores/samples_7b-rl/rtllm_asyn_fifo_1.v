
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);
localparam PTR_WIDTH = ADDR_WIDTH + 1;


reg [PTR_WIDTH-1:0] wptr_bin;
wire [PTR_WIDTH-1:0] wptr_gray;
reg [PTR_WIDTH-1:0] rgray_sync1_w, rgray_sync2_w;


reg [PTR_WIDTH-1:0] rptr_bin;
wire [PTR_WIDTH-1:0] rptr_gray;
reg [PTR_WIDTH-1:0] wgray_sync1_r, wgray_sync2_r;


wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];


dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram (
    .wclk(wclk),
    .wenc(winc & ~wfull),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & ~rempty),
    .raddr(raddr),
    .rdata(rdata)
);


assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rgray_sync1_w <= 0;
        rgray_sync2_w <= 0;
    end else begin
        rgray_sync1_w <= rptr_gray;
        rgray_sync2_w <= rgray_sync1_w;
    end
end


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wgray_sync1_r <= 0;
        wgray_sync2_r <= 0;
    end else begin
        wgray_sync1_r <= wptr_gray;
        wgray_sync2_r <= wgray_sync1_r;
    end
end


function [PTR_WIDTH-1:0] gray2bin;
    input [PTR_WIDTH-1:0] gray;
    integer i;
    begin
        gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
        for (i = PTR_WIDTH-2;
 i >= 0;
 i = i-1)
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
    end
endfunction

wire [PTR_WIDTH-1:0] rptr_sync_bin = gray2bin(rgray_sync2_w);
wire [PTR_WIDTH-1:0] wptr_sync_bin = gray2bin(wgray_sync2_r);


wire wfull_next = ((wptr_bin[PTR_WIDTH-1] != rptr_sync_bin[PTR_WIDTH-1]) && 
                  (wptr_bin[PTR_WIDTH-2:0] == rptr_sync_bin[PTR_WIDTH-2:0]));
wire rempty_next = (rptr_bin == wptr_sync_bin);


reg wfull_reg;
reg rempty_reg;

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wfull_reg <= 0;
    else
        wfull_reg <= wfull_next;
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rempty_reg <= 1;
    else
        rempty_reg <= rempty_next;
end


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wptr_bin <= 0;
    else if (winc && !wfull_reg)
        wptr_bin <= wptr_bin + 1;
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rptr_bin <= 0;
    else if (rinc && !rempty_reg)
        rptr_bin <= rptr_bin + 1;
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] mem [0:DEPTH-1];

always @(posedge wclk) begin
    if (wenc)
        mem[waddr] <= wdata;
end

always @(posedge rclk) begin
    if (renc)
        rdata <= mem[raddr];
end

endmodule
