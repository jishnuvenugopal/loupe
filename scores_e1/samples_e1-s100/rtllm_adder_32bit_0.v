
module adder_32bit (
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C32
);


module cla_16bit (
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C
);

    
    reg [15:0] sum;
    reg [15:0] carry;

    
    assign sum = A + B;

    
    assign carry = sum[31];

    
    assign S = sum[15:0];
    assign C = carry;

endmodule


module adder_32bit (
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C32
);

    
    cla_16bit cla1 [15:0];

    
    for (genvar i = 0;
 i < 16;
 i = i + 1) begin
        assign cla1[i].A = A[i*16:(i+1)*16];
        assign cla1[i].B = B[i*16:(i+1)*16];
        assign cla1[i].S = S[i*16:(i+1)*16];
        assign cla1[i].C = C32;
    end

endmodule
