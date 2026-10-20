
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wrstn,
    input rclk,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output rempty,
    output wfull,
    output [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);
localparam PTR_WIDTH = ADDR_WIDTH + 1;


reg [PTR_WIDTH-1:0] wbin, wgray;
reg [PTR_WIDTH-1:0] wgray_sync_r1, wgray_sync_r2;


reg [PTR_WIDTH-1:0] rbin, rgray;
reg [PTR_WIDTH-1:0] rgray_sync_w1, rgray_sync_w2;


wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];
wire wenc = winc && !wfull;
wire renc = rinc && !rempty;


dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .renc(renc),
    .rclk(rclk),
    .raddr(raddr),
    .rdata(rdata)
);


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wbin <= 0;
        wgray <= 0;
    end else if (winc && !wfull) begin
        wbin <= wbin + 1;
        wgray <= (wbin + 1) ^ ((wbin + 1) >> 1);
    end
end


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rbin <= 0;
        rgray <= 0;
    end else if (rinc && !rempty) begin
        rbin <= rbin + 1;
        rgray <= (rbin + 1) ^ ((rbin + 1) >> 1);
    end
end


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rgray_sync_w1 <= 0;
        rgray_sync_w2 <= 0;
    end else begin
        rgray_sync_w1 <= rgray;
        rgray_sync_w2 <= rgray_sync_w1;
    end
end


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wgray_sync_r1 <= 0;
        wgray_sync_r2 <= 0;
    end else begin
        wgray_sync_r1 <= wgray;
        wgray_sync_r2 <= wgray_sync_r1;
    end
end


assign wfull = (wgray == {~rgray_sync_w2[PTR_WIDTH-1 -:2], rgray_sync_w2[ADDR_WIDTH-1:0]});
assign rempty = (rgray == wgray_sync_r2);

endmodule


module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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
