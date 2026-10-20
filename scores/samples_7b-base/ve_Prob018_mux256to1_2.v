
module TopModule (
    input [255:0] in,
    input [7:0] sel,
    output reg out
);

always @(*) begin
    assign out = in[sel];
end

endmodule
