
module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

always @(posedge a) begin
    case (a)
        3'b000: q = 16'b1232;
        3'b001: q = 16'b1232;
        3'b010: q = 16'b1232;
        3'b011: q = 16'b1232;
        3'b100: q = 16'b1232;
        3'b101: q = 16'b1232;
        3'b110: q = 16'b1232;
        3'b111: q = 16'b1232;
    endcase
end

endmodule
