
module comparator_4bit (
    input [3:0] A, 
    input [3:0] B, 
    output reg A_greater, 
    output reg A_equal,   
    output reg A_less    
);

    
    wire [3:0] diff;
 
    wire [3:0] borrow;
 

    
    subtractor_4bit #(.N(4)) sub (
        .A(A),
        .B(B),
        .diff(diff),
        .borrow(borrow)
    );

    
    always @(*) begin
        A_greater = 0;
        A_equal = 0;
        A_less = 0;

        
        if (diff != 0) begin
            A_greater = 1;
        end

        
        if (diff == 0) begin
            A_equal = 1;
        end

        
        if (borrow == 1) begin
            A_less = 1;
        end
    end

endmodule


module subtractor_4bit (
    input [3:0] A, 
    input [3:0] B, 
    output reg [3:0] diff, 
    output reg borrow 
);

    
    wire [3:0] sum;
    wire [3:0] carry_in;
    wire [3:0] carry_out;

    
    full_adder #(.N(4)) fa0 (
        .A(A[3]),
        .B(B[3]),
        .Cin(carry_in[0]),
        .Sum(sum[3]),
        .Cout(carry_out[0])
    );
    full_adder #(.N(4)) fa1 (
        .A(A[2]),
        .B(B[2]),
        .Cin(carry_out[0]),
        .Sum(sum[2]),
        .Cout(carry_out[1])
    );
    full_adder #(.N(4)) fa2 (
        .A(A[1]),
        .B(B[1]),
        .Cin(carry_out[1]),
        .Sum(sum[1]),
        .Cout(carry_out[2])
    );
    full_adder #(.N(4)) fa3 (
        .A(A[0]),
        .B(B[0]),
        .Cin(carry_out[2]),
        .Sum(sum[0]),
        .Cout(carry_out[3])
    );

    
    assign diff = sum;
    assign borrow = carry_out[3];

endmodule


module full_adder (
    input [3:0] A, 
    input [3:0] B, 
    input Cin,     
    output reg Sum, 
    output reg Cout 
);

    
    wire [3:0] sum;
    wire [3:0] carry;

    
    half_adder #(.N(4)) ha0 (
        .A(A[3]),
        .B(B[3]),
        .Sum(sum[3]),
        .Cout(carry[0])
    );
    half_adder #(.N(4)) ha1 (
        .A(A[2]),
        .B(B[2]),
        .Sum(sum[2]),
        .Cout(carry[1])
    );
    half_adder #(.N(4)) ha2 (
        .A(A[1]),
        .B(B[1]),
        .Sum(sum[1]),
        .Cout(carry[2])
    );
    half_adder #(.N(4)) ha3 (
        .A(A[0]),
        .B(B[0]),
        .Sum(sum[0]),
        .Cout(carry[3])
    );

    
    assign Sum = sum[3] ^ Cin;
    assign Cout = carry[3] | carry[0];

endmodule


module half_adder (
    input [3:0] A, 
    input [3:0] B, 
    output reg Sum, 
    output reg Cout 
);

    
    assign Sum = A ^ B;
    assign Cout = A & B;

endmodule
