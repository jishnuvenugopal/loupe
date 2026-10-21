
module TopModule (
    input wire [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        out_both <= 4'b0;
        out_any <= 4'b0;
        out_different <= 4'b0;
    end else begin
        out_both[0] <= (in[0] == in[1]) ? 1'b1 : 1'b0;
        out_both[1] <= (in[1] == in[2]) ? 1'b1 : 1'b0;
        out_both[2] <= (in[2] == in[3]) ? 1'b1 : 1'b0;
        out_both[3] <= 1'b0;
 

        out_any[0] <= (in[0] == in[1]) || (in[0] == in[2]) ? 1'b1 : 1'b0;
        out_any[1] <= (in[1] == in[2]) || (in[1] == in[3]) ? 1'b1 : 1'b0;
        out_any[2] <= (in[2] == in[3]) || (in[2] == in[0]) ? 1'b1 : 1'b0;
        out_any[3] <= 1'b0;
 

        out_different[0] <= (in[0] != in[1]) ? 1'b1 : 1'b0;
        out_different[1] <= (in[1] != in[2]) ? 1'b1 : 1'b0;
        out_different[2] <= (in[2] != in[3]) ? 1'b1 : 1'b0;
        out_different[3] <= 1'b0;
 
    end
end

endmodule
