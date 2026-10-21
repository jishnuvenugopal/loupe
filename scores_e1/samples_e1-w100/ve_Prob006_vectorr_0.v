
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    
    function [7:0] reverseBitOrder(input [7:0] data);
        reverseBitOrder = {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
    endfunction

    
    assign out = reverseBitOrder(in);

endmodule
