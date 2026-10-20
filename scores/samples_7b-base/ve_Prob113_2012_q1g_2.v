
module TopModule (
    input [1:0] x[1:0],
    output f
);

always @(*) begin
    case ({x[1], x[0]})
        2'b00: f = 1'b1;
        2'b01: f = 1'b0;
        2'b11: f = 1'b1;
        2'b10: f = 1'b1;
        default: f = 1'b0;
 
    endcase
end

endmodule
