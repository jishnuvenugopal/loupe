
module TopModule(
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y_next;

always @(*) begin
    case(y)
        3'b000: Y_next = x ? 3'b001 : 3'b000;
        3'b001: Y_next = x ? 3'b100 : 3'b001;
        3'b010: Y_next = x ? 3'b001 : 3'b010;
        3'b011: Y_next = x ? 3'b010 : 3'b001;
        3'b100: Y_next = x ? 3'b100 : 3'b011;
        default: Y_next = 3'b000;
    endcase
end

assign Y0 = Y_next[0];
assign z = (y == 3'b011 && x) || (y == 3'b100 && !x);

endmodule
