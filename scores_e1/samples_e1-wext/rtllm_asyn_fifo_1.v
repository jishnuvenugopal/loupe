
module asyn_fifo (
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata,
    output reg wfull,
    output reg rempty
);

    parameter WIDTH = 8,
             DEPTH = 16;

    
    dual_port_ram dual_port_ram (
        .wclk(wclk),
        .rclk(rclk),
        .wen(wen),
        .ren(ren),
        .wdata(wdata),
        .rdata(rdata),
        .waddr(waddr),
        .raddr(raddr)
    );

    
    reg [WIDTH-1:0] rptr_syn;
    reg [WIDTH-1:0] rptr_buff;
    reg [WIDTH-1:0] wptr_buff;

    always @(posedge rclk or posedge rrstn) begin
        if (~rrstn) begin
            rptr_syn <= 0;
            rptr_buff <= 0;
            wptr_buff <= 0;
        end else begin
            rptr_buff <= rptr_syn;
            wptr_buff <= wptr;
            rptr_syn <= rptr_buff;
        end
    end

    
    reg [WIDTH-1:0] wptr_syn;
    reg [WIDTH-1:0] wptr_buff;

    always @(posedge wclk or posedge wrstn) begin
        if (~wrstn) begin
            wptr_syn <= 0;
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
            wptr_syn <= wptr_buff;
        end
    end

    
    assign wfull = (wptr == ~rptr_syn);
    assign rempty = (rptr == wptr);

endmodule
