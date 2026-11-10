
module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

    
    reg [15:0] selectedBit;

    
    always @(*) begin
        case (sel)
            4'b0000: selectedBit = a;
            4'b0001: selectedBit = b;
            4'b0010: selectedBit = c;
            4'b0011: selectedBit = d;
            4'b0100: selectedBit = e;
            4'b0101: selectedBit = f;
            4'b0110: selectedBit = g;
            4'b0111: selectedBit = h;
            4'b1000: selectedBit = i;
            default: selectedBit = 16'b11111111;
 
        endcase
    end

    
    assign out = selectedBit;

endmodule
