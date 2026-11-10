
module TopModule (
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out
);

    
    XNOR xnor1 (
        .A(in1),
        .B(in2),
        .Y(out)
    );

    
    XOR xor1 (
        .A(xnor1.Y),
        .B(in3),
        .Y(out)
    );

endmodule


module XNOR (
    input wire A,
    input wire B,
    output reg Y
);

    always @(*) begin
        if (A == B) begin
            Y = 1'b0;
        end else begin
            Y = 1'b1;
        end
    end

endmodule


module XOR (
    input wire A,
    input wire B,
    output reg Y
);

    always @(*) begin
        if (A == B) begin
            Y = 1'b0;
        end else begin
            Y = 1'b1;
        end
    end

endmodule
