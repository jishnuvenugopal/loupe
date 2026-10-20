
module asyn_fifo #(parameter DEPTH = 16, parameter WIDTH = 8) (
    input wclk,
    input rclk,
    input [WIDTH-1:0] wdata,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);


localparam ADDR_WIDTH = $clog2(DEPTH);


reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];


reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
reg [ADDR_WIDTH-1:0] wptr, rptr, rptr_syn, wptr_buff, rptr_buff;


always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
        wptr_buff <= 0;
    end else begin
        wptr <= (winc) ? (wptr + 1) : wptr;
        wptr_buff <= wptr;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr <= 0;
        rptr_syn <= 0;
        rptr_buff <= 0;
    end else begin
        rptr <= (rinc) ? (rptr + 1) : rptr;
        rptr_syn <= rptr;
        rptr_buff <= rptr;
    end
end


assign wptr = (wptr_buff[ADDR_WIDTH-2] ^ wptr_buff[ADDR_WIDTH-3]) ? {wptr_buff[ADDR_WIDTH-2:0], wptr_buff[ADDR_WIDTH-3]} : wptr_buff;
assign rptr = (rptr_syn[ADDR_WIDTH-2] ^ rptr_syn[ADDR_WIDTH-3]) ? {rptr_syn[ADDR_WIDTH-2:0], rptr_syn[ADDR_WIDTH-3]} : rptr_syn;


assign wfull = (wptr_syn == {~rptr_syn[ADDR_WIDTH-2], rptr_syn[ADDR_WIDTH-3:0]});
assign rempty = (rptr_syn == wptr_syn);


assign rdata = RAM_MEM[rptr];


wire wen, ren;
assign wen = wrstn & winc;
assign ren = rrstn & rinc;


always @(posedge wclk or posedge rclk) begin
    if (wen) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
    if (ren) begin
        rdata <= RAM_MEM[raddr_bin];
    end
end


assign waddr_bin = wptr & (DEPTH - 1);
assign raddr_bin = rptr & (DEPTH - 1);

endmodule
