
module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    
    wire temp1;
    wire temp2;

    NAND4 nand1 (.A(p1a), .B(p1b), .C(p1c), .D(p1d), .Y(temp1));
    NAND4 nand2 (.A(p2a), .B(p2b), .C(p2c), .D(p2d), .Y(temp2));

    
    AND2 and1 (.A(temp1), .B(1'b1), .Y(p1y));
    AND2 and2 (.A(temp2), .B(1'b1), .Y(p2y));

endmodule

module NAND4 (
    input A,
    input B,
    input C,
    input D,
    output Y
);
    assign Y = ~(A & B & C & D);
endmodule

module AND2 (
    input A,
    input B,
    output Y
);
    assign Y = A & B;
endmodule
