
module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);

    
    wire xor_out;

    
    wire nor_out;

    
    XORGate xor_inst (
        .A(in1),
        .B(in2),
        .Y(xor_out)
    );

    
    NOTGate not_inst (
        .A(xor_out),
        .Y(nor_out)
    );

    
    assign out = nor_out;

endmodule


module XORGate (
    input wire A,
    input wire B,
    output wire Y
);

    
    assign Y = A ^ B;

endmodule


module NOTGate (
    input wire A,
    output wire Y
);

    
    assign Y = ~A;

endmodule
