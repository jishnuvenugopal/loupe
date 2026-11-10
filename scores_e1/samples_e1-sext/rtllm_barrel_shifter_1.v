
module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output reg [7:0] out
);

always @(*) begin
    
    out = in;

    
    if (ctrl[2] == 1'b1) begin
        
        out = out >> 4;
        
        out = out << 4;
    end else if (ctrl[1] == 1'b1) begin
        
        out = out >> 2;
        
        out = out << 2;
    end else if (ctrl[0] == 1'b1) begin
        
        out = out >> 1;
        
        out = out << 1;
    end
end

endmodule
