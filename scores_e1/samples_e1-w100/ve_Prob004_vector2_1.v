
module TopModule (
    input wire [31:0] in,
    output wire [31:0] out
);

    
    function [31:0] reverse_byte_order(input [31:0] word);
        
        reverse_byte_order = {word[7:0], word[15:8], word[23:16], word[31:24]};
    endfunction

    
    out = reverse_byte_order(in);

endmodule
