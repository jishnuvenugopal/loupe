
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    
    wire [3:0] Sum_internal;
    wire [3:0] Carry_internal;

    
    adder #(.WIDTH(4)) binary_adder (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum_internal),
        .Cout(Carry_internal)
    );

    
    assign Sum_corrected = Sum_internal + 6;

    
    always @(*) begin
        if (Sum_corrected > 9) begin
            Sum = Sum_corrected - 10;
            Cout = 1'b1;
        end else begin
            Sum = Sum_corrected;
            Cout = Carry_internal;
        end
    end

endmodule
