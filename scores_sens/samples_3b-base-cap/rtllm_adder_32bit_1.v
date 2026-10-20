
module adder_32bit(
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] S,
    output reg C32
);

    
    adder_16bit adder16a(.A(A[31:16]), .B(B[31:16]), .S(S[31:16]), .C16(C32));
    adder_16bit adder16b(.A(A[15:0]), .B(B[15:0]), .S(S[15:0]), .C16(C32));

endmodule


module adder_16bit(
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C16
);

    
    wire [15:0] Cg;
    wire [15:0] Cp;

    
    generate
        for (genvar i = 0;
 i < 16;
 i = i + 1) begin
            assign Cg[i] = A[i] & B[i];
            assign Cp[i] = A[i] | B[i];
        end
    endgenerate

    
    generate
        for (genvar i = 1;
 i < 16;
 i = i + 1) begin
            assign Cg[i] = Cg[i] | (Cp[i-1] & Cg[i-1]);
            assign Cp[i] = Cp[i] | Cp[i-1];
        end
    endgenerate

    
    assign S = A + B + Cg;

    
    assign C16 = Cp[15];

endmodule
