
module adder_32bit (
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] S,
    output reg C32
);


module cla (
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C
);

    
    reg [15:0] sum;
    reg [15:0] carry;

    always @(*) begin
        sum = A + B + carry;
        carry = sum[16];
        S = sum[0:15];
    end

endmodule


module adder_32bit_top (
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] S,
    output reg C32
);

    
    cla cla_inst (
        .A(A[15:0]),
        .B(B[15:0]),
        .S(S[15:0]),
        .C(C)
    );

    
    assign C32 = C;

endmodule

endmodule
