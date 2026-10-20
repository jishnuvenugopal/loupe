
module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q;
reg [511:0] nxt;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (integer i = 0;
 i < 512;
 i = i + 1) begin
            if (i == 0) begin
                nxt[i] <= 0;
            end else if (i == 511) begin
                nxt[i] <= 0;
            end else begin
                case ({q[i-1], q[i], q[i+1]})
                    3'b111: nxt[i] <= 0;
                    3'b110: nxt[i] <= 1;
                    3'b101: nxt[i] <= 1;
                    3'b100: nxt[i] <= 0;
                    3'b011: nxt[i] <= 1;
                    3'b010: nxt[i] <= 1;
                    3'b001: nxt[i] <= 1;
                    3'b000: nxt[i] <= 0;
                    default: nxt[i] <= 0;
                endcase
            end
        end
        q <= nxt;
    end
end

assign q = load ? data : 512'b0;

endmodule
