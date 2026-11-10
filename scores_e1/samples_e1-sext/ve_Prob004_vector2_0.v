
module TopModule (
    input wire [31:0] in,
    output reg [31:0] out
);

function [31:0] reverse_byte_order(input [31:0] data);
    reg [31:0] reversed_data;
    integer i;

    for (i = 0;
 i < 4;
 i++) begin
        reversed_data = reversed_data << 8;
        reversed_data = reversed_data | (data >> (i * 8));
    end

    return reversed_data;
endfunction

assign out = reverse_byte_order(in);

endmodule
