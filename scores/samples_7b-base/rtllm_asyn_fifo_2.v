
module asyn_fifo #(parameter WIDTH = 8, parameter DEPTH = 16) (
    input wire [WIDTH-1:0] wdata,
    input wire wclk,
    input wire wrstn,
    input wire winc,
    input wire rclk,
    input wire rrstn,
    input wire rinc,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);


    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
    reg [WIDTH-1:0] rdata;
    wire [$clog2(DEPTH)-1:0] waddr, raddr, waddr_gray, raddr_gray;


    reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    reg [$clog2(DEPTH)-1:0] wptr, rptr, wptr_syn, rptr_syn;
    reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;


    wire [$clog2(DEPTH)-1:0] waddr_gray_calc, raddr_gray_calc;


    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end


    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end


    assign waddr_gray_calc = waddr_bin ^ (waddr_bin >> 1);
    assign raddr_gray_calc = raddr_bin ^ (raddr_bin >> 1);


    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else begin
            wptr <= wptr_buff;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else begin
            rptr <= rptr_buff;
        end
    end


    assign wptr_syn = wptr_buff;
    assign rptr_syn = rptr_buff;

    assign wfull = (wptr_syn == (rptr_syn ^ {1'b0, {($clog2(DEPTH)-2){1'b1}}}));
    assign rempty = (wptr_syn == rptr_syn);


    assign rdata = RAM_MEM[raddr_bin];


    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            RAM_MEM <= 0;
        end else if (winc) begin
            RAM_MEM[waddr_bin] <= wdata;
        end
    end

endmodule
