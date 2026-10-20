
module TopModule (
    input [3:0] in,
    output reg [2:0] out_both,
    output reg [2:0] out_any,
    output reg [2:0] out_different
);

    always @(*) begin
        
        out_both[0] = 1'b0;
        out_both[1] = (in[1] & in[0]);
        out_both[2] = (in[2] & in[1]);
        out_both[3] = (in[3] & in[2]);

        
        out_any[0] = (in[0] | in[1]);
        out_any[1] = (in[1] | in[2]);
        out_any[2] = (in[2] | in[3]);

        
        out_different[0] = (in[0] != in[3]);
        out_different[1] = (in[1] != in[0]);
        out_different[2] = (in[2] != in[1]);
    end

endmodule
