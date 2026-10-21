
module top (
    input wire x,
    input wire y,
    output wire z
);


module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule


module B (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule


assign A1.x = x;
assign A1.y = y;
assign A2.x = x;
assign A2.y = y;
assign B1.x = x;
assign B1.y = y;
assign B2.x = x;
assign B2.y = y;


assign OR1.z = A1.z | A2.z;
assign AND1.z = A1.z & A2.z;
assign AND2.z = A1.z & B2.z;
assign AND3.z = A2.z & B2.z;
assign XOR1.z = OR1.z ^ AND1.z ^ AND2.z ^ AND3.z;


assign z = XOR1.z;

endmodule
