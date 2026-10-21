
module top_level (
    input wire x,
    input wire y,
    output wire z
);


module a (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x ^ y;
endmodule


module b (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x & y;
endmodule


assign a1.x = x;
assign a1.y = y;
assign a2.x = x;
assign a2.y = y;
assign b1.x = x;
assign b1.y = y;
assign b2.x = x;
assign b2.y = y;


assign a1.z = a1.z;
assign a2.z = a2.z;
assign b1.z = b1.z;
assign b2.z = b2.z;


assign or1.x = a1.z;
assign or1.y = a2.z;
assign and1.x = a1.z;
assign and1.y = a2.z;
assign or2.x = b1.z;
assign or2.y = b2.z;
assign and2.x = b1.z;
assign and2.y = b2.z;
assign xor1.x = or1.z;
assign xor1.y = and1.z;
assign xor2.x = or2.z;
assign xor2.y = and2.z;


assign z = xor1.z;

endmodule
