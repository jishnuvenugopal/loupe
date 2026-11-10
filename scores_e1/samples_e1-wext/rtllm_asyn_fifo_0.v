
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


dual_port_ram dual_port_ram (
    .wclk(wclk),
    .rclk(rclk),
    .wen(wen),
    .ren(ren),
    .waddr(waddr),
    .wdata(wdata),
    .raddr(raddr),
    .rdata(rdata)
);


reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_syn;
reg [3:0] rptr_syn;

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr <= 4'b0000;
        rptr <= 4'b0000;
        wptr_syn <= 4'b0000;
        rptr_syn <= 4'b0000;
    end else begin
        wptr <= wptr + 1'b1;
        rptr <= rptr + 1'b1;
        wptr_syn <= wptr;
        rptr_syn <= rptr;
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        wptr <= 4'b0000;
        rptr <= 4'b0000;
        wptr_syn <= 4'b0000;
        rptr_syn <= 4'b0000;
    end else begin
        wptr <= wptr;
        rptr <= rptr + 1'b1;
        wptr_syn <= wptr;
        rptr_syn <= rptr;
    end
end


always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wen <= 1'b0;
    end else begin
        wen <= winc;
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        ren <= 1'b0;
    end else begin
        ren <= rinc;
    end
end


always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wfull <= 1'b0;
        rempty <= 1'b0;
    end else begin
        if (wptr == ~rptr) begin
            wfull <= 1'b1;
        end else begin
            wfull <= 1'b0;
        end
        if (rptr == wptr) begin
            rempty <= 1'b1;
        end else begin
            rempty <= 1'b0;
        end
    end
end


assign wdata = dual_port_ram.wdata;
assign rdata = dual_port_ram.rdata;

endmodule

module dual_port_ram (
    input wire wclk,
    input wire rclk,
    input wire wen,
    input wire ren,
    input wire [3:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire [3:0] raddr,
    output reg [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM[0:DEPTH-1][0:WIDTH-1];

always @(posedge wclk or posedge wen) begin
    if (wen) begin
        RAM_MEM[waddr][WIDTH-1:0] <= wdata;
    end
end

always @(posedge rclk or posedge ren) begin
    if (ren) begin
        rdata <= RAM_MEM[raddr][WIDTH-1:0];
    end
end

endmodule
