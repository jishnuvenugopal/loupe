
module TopModule (
    input wire [3:0] in,  
    output reg [3:0] out_both,  
    output reg [3:0] out_any,  
    output reg [3:0] out_different  
);

    
    function reg [3:0] both_bits;
        both_bits = (in[0] && in[1]) || (in[1] && in[2]) || (in[2] && in[3]);
    endfunction

    
    function reg [3:0] any_bits;
        any_bits = (in[0] || in[1] || in[2] || in[3]);
    endfunction

    
    function reg [3:0] different_bits;
        different_bits = (in[0] != in[1]) || (in[1] != in[2]) || (in[2] != in[3]);
    endfunction

    
    assign out_both = both_bits;
    assign out_any = any_bits;
    assign out_different = different_bits;

endmodule
