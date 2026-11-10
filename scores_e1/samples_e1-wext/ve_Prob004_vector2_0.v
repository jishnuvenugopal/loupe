
module TopModule (
    input wire [31:0] in,
    output wire [31:0] out
);

function [31:0] reverse_byte_order(input [31:0] data);
    
    wire [7:0] byte0 = data[7:0];
    wire [7:0] byte1 = data[15:8];
    wire [7:0] byte2 = data[23:16];
    wire [7:0] byte3 = data[31:24];
    
    reverse_byte_order = {byte3, byte2, byte1, byte0};
endfunction

assign out = reverse_byte_order(in);

endmodule
