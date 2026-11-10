
module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output reg [7:0] out
);

always @(*) begin
    
    case (ctrl)
        3'b000: out = in;
 
        3'b001: out = in[3:0];
 
        3'b010: out = in[2:0];
 
        3'b011: out = in[1:0];
 
        3'b100: out = in[0];
 
        3'b101: out = in[0] | in[1];
 
        3'b110: out = in[0] | in[1] | in[2];
 
        3'b111: out = in[0] | in[1] | in[2] | in[3];
 
        default: out = in;
 
    endcase
end

endmodule
