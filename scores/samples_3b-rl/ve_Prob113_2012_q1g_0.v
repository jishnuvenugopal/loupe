
module TopModule (
    input [3:0] x,
    output reg f
);

    
    reg [15:0] kmap = 16'b0000000000000001;

    always @(*) begin
        case (x)
            4'b0000: f = kmap[0];
            4'b0001: f = kmap[1];
            4'b0010: f = kmap[2];
            4'b0011: f = kmap[3];
            4'b0100: f = kmap[4];
            4'b0101: f = kmap[5];
            4'b0110: f = kmap[6];
            4'b0111: f = kmap[7];
            4'b1000: f = kmap[8];
            4'b1001: f = kmap[9];
            4'b1010: f = kmap[10];
            4'b1011: f = kmap[11];
            4'b1100: f = kmap[12];
            4'b1101: f = kmap[13];
            4'b1110: f = kmap[14];
            4'b1111: f = kmap[15];
            default: f = 1'b0;
        endcase
    end

endmodule
