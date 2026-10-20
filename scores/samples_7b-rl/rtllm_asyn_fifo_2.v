
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    
    input wclk,
    input wrstn,
    input winc,
    input [WIDTH-1:0] wdata,
    output wfull,
    
    
    input rclk,
    input rrstn,
    input rinc,
    output [WIDTH-1:0] rdata,
    output rempty
);

localparam ADDR_WIDTH = $clog2(DEPTH);
localparam PTR_WIDTH = ADDR_WIDTH + 1;


reg [PTR_WIDTH-1:0] wbin, rbin;
wire [PTR_WIDTH-1:0] wgray, rgray;


reg [PTR_WIDTH-1:0] rgray_sync1, rgray_sync;
reg [PTR_WIDTH-1:0] wgray_sync1, wgray_sync;


wire wen = winc && !wfull;
wire ren = rinc && !rempty;


wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];


dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wbin <= 0;
    end else begin
        if (wen) wbin <= wbin + 1;
    end
end


assign wgray = (wbin >> 1) ^ wbin;


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rbin <= 0;
    end else begin
        if (ren) rbin <= rbin + 1;
    end
end


assign rgray = (rbin >> 1) ^ rbin;


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        {rgray_sync1, rgray_sync} <= 0;
    end else begin
        rgray_sync1 <= rgray;
        rgray_sync <= rgray_sync1;
    end
end


always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        {wgray_sync1, wgray_sync} <= 0;
    end else begin
        wgray_sync1 <= wgray;
        wgray_sync <= wgray_sync1;
    end
end


assign wfull = (wgray[PTR_WIDTH-1] != rgray_sync[PTR_WIDTH-1]) &&
               (wgray[PTR_WIDTH-2:0] == rgray_sync[PTR_WIDTH-2:0]);

assign rempty = (rgray == wgray_sync);

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

reg [WIDTH-1:0] RAM [0:DEPTH-1];


always @(posedge wclk) begin
    if (wenc)
        RAM[waddr] <= wdata;
end


always @(posedge rclk) begin
    if (renc)
        rdata <= RAM[raddr];
end

endmodule
