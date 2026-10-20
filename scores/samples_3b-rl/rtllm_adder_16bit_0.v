
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [7:0] sum0, sum1;
    wire [7:0] carry0, carry1;
    wire [7:0] sum2, sum3;
    wire [7:0] carry2, carry3;
    wire [7:0] sum4, sum5;
    wire [7:0] carry4, carry5;
    wire [7:0] sum6, sum7;
    wire [7:0] carry6, carry7;
    wire [7:0] sum8, sum9;
    wire [7:0] carry8, carry9;
    wire [7:0] sum10, sum11;
    wire [7:0] carry10, carry11;
    wire [7:0] sum12, sum13;
    wire [7:0] carry12, carry13;
    wire [7:0] sum14, sum15;
    wire [7:0] carry14, carry15;
    wire [7:0] sum16;
    wire [7:0] carry16;

    
    assign sum0 = a[7:0] + b[7:0] + Cin;
    assign carry0 = sum0[8];

    
    assign sum1 = a[15:8] + b[15:8] + carry0;
    assign carry1 = sum1[8];

    
    assign sum2 = a[23:16] + b[23:16] + carry1;
    assign carry2 = sum2[8];

    
    assign sum3 = a[31:24] + b[31:24] + carry2;
    assign carry3 = sum3[8];

    
    assign sum4 = a[39:32] + b[39:32] + carry3;
    assign carry4 = sum4[8];

    
    assign sum5 = a[47:40] + b[47:40] + carry4;
    assign carry5 = sum5[8];

    
    assign sum6 = a[55:48] + b[55:48] + carry5;
    assign carry6 = sum6[8];

    
    assign sum7 = a[63:56] + b[63:56] + carry6;
    assign carry7 = sum7[8];

    
    assign sum8 = a[71:64] + b[71:64] + carry7;
    assign carry8 = sum8[8];

    
    assign sum9 = a[79:72] + b[79:72] + carry8;
    assign carry9 = sum9[8];

    
    assign sum10 = a[87:80] + b[87:80] + carry9;
    assign carry10 = sum10[8];

    
    assign sum11 = a[95:88] + b[95:88] + carry10;
    assign carry11 = sum11[8];

    
    assign sum12 = a[103:96] + b[103:96] + carry11;
    assign carry12 = sum12[8];

    
    assign sum13 = a[111:104] + b[111:104] + carry12;
    assign carry13 = sum13[8];

    
    assign sum14 = a[119:112] + b[119:112] + carry13;
    assign carry14 = sum14[8];

    
    assign sum15 = a[127:120] + b[127:120] + carry14;
    assign carry15 = sum15[8];

    
    assign sum16 = a[135:128] + b[135:128] + carry15;
    assign Co = sum16[8];

    
    assign y[7:0] = sum0;
    assign y[15:8] = sum1;
    assign y[23:16] = sum2;
    assign y[31:24] = sum3;
    assign y[39:32] = sum4;
    assign y[47:40] = sum5;
    assign y[55:48] = sum6;
    assign y[63:56] = sum7;
    assign y[71:64] = sum8;
    assign y[79:72] = sum9;
    assign y[87:80] = sum10;
    assign y[95:88] = sum11;
    assign y[103:96] = sum12;
    assign y[111:104] = sum13;
    assign y[119:112] = sum14;
    assign y[127:120] = sum15;
    assign y[135:128] = sum16;

endmodule
