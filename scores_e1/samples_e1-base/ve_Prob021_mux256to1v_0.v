
module TopModule (
    input  [1023:0] in,  
    input  [7:0]   sel,  
    output [3:0]  out   
);

    
    function [1023:0] pack(input [1023:0] in);
        pack = in;
    endfunction

    
    always @(*) begin
        case (sel)
            8'b0000: out = pack(in[3:0]);
            8'b0001: out = pack(in[7:4]);
            8'b0010: out = pack(in[11:8]);
            8'b0011: out = pack(in[15:12]);
            8'b0100: out = pack(in[19:16]);
            8'b0101: out = pack(in[23:20]);
            8'b0110: out = pack(in[27:24]);
            8'b0111: out = pack(in[31:28]);
            8'b1000: out = pack(in[35:32]);
            8'b1001: out = pack(in[39:36]);
            8'b1010: out = pack(in[43:40]);
            8'b1011: out = pack(in[47:44]);
            8'b1100: out = pack(in[51:48]);
            8'b1101: out = pack(in[55:52]);
            8'b1110: out = pack(in[59:56]);
            8'b1111: out = pack(in[63:60]);
        endcase
    end

endmodule
