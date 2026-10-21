
module TopModule (
    input wire [7:0] code,
    input wire valid,
    output reg [3:0] out,
    output reg valid_out
);

always @(posedge valid) begin
    case (code)
        8'h45: out = 4'b0000;
        8'h16: out = 4'b0001;
        8'h1e: out = 4'b0010;
        8'h26: out = 4'b0011;
        8'h25: out = 4'b0100;
        8'h2e: out = 4'b0101;
        8'h36: out = 4'b0110;
        8'h3d: out = 4'b0111;
        8'h3e: out = 4'b1000;
        8'h46: out = 4'b1001;
        default: out = 4'b0000;
    endcase
    valid_out = (out != 4'b0000);
end

endmodule
