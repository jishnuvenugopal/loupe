
module TopModule (
    input [3:0] x,
    output reg [3:0] f
);

always @(*) begin
    case (x)
        4'b0000: f = 4'b0000;
        4'b0001: f = 4'b0000;
        4'b0010: f = 4'b0000;
        4'b0011: f = 4'b0001;
        4'b0100: f = 4'b0000;
        4'b0101: f = 4'b0001;
        4'b0110: f = 4'b0001;
        4'b0111: f = 4'b0000;
        4'b1000: f = 4'b0000;
        4'b1001: f = 4'b0001;
        4'b1010: f = 4'b0001;
        4'b1011: f = 4'b0000;
        4'b1100: f = 4'b0000;
        4'b1101: f = 4'b0001;
        4'b1110: f = 4'b0000;
        4'b1111: f = 4'b0000;
        default: f = 4'b0000;
    endcase
end

endmodule
