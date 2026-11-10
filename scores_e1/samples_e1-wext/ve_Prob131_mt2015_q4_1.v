
module top_level (
    input wire x,
    input wire y,
    output reg z
);


module A (
    input wire x,
    input wire y,
    output reg z
);
    assign z = (x ^ y) & x;
endmodule


module B (
    input wire x,
    input wire y,
    output reg z
);
    assign z = (x ^ y) & x;
endmodule


assign A1.x = x;
assign A1.y = y;
assign A1.z = A1.z;

assign A2.x = x;
assign A2.y = y;
assign A2.z = A2.z;

assign B1.x = x;
assign B1.y = y;
assign B1.z = B1.z;

assign B2.x = x;
assign B2.y = y;
assign B2.z = B2.z;

assign OR1.x = A1.z;
assign OR1.y = A2.z;
assign OR1.z = OR1.z;

assign AND1.x = A1.z;
assign AND1.y = A2.z;
assign AND1.z = AND1.z;

assign XOR1.x = OR1.z;
assign XOR1.y = AND1.z;
assign XOR1.z = XOR1.z;

endmodule
