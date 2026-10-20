
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    
    wire [3:0] abcd;
    assign abcd = {a, b, c, d};

    
    wire [3:0] m7 = 4'b1111;
    wire [3:0] m2 = 4'b0010;
    wire [3:0] m15 = 4'b1111;
    wire sop_m7 = (abcd == m7);
    wire sop_m2 = (abcd == m2);
    wire sop_m15 = (abcd == m15);
    assign out_sop = sop_m7 | sop_m2 | sop_m15;

    
    wire [3:0] m0 = 4'b0000;
    wire [3:0] m1 = 4'b0001;
    wire [3:0] m4 = 4'b0100;
    wire [3:0] m5 = 4'b0101;
    wire [3:0] m6 = 4'b0110;
    wire [3:0] m9 = 4'b1001;
    wire [3:0] m10 = 4'b1010;
    wire [3:0] m13 = 4'b1101;
    wire [3:0] m14 = 4'b1110;
    wire pos_m0 = (abcd != m0);
    wire pos_m1 = (abcd != m1);
    wire pos_m4 = (abcd != m4);
    wire pos_m5 = (abcd != m5);
    wire pos_m6 = (abcd != m6);
    wire pos_m9 = (abcd != m9);
    wire pos_m10 = (abcd != m10);
    wire pos_m13 = (abcd != m13);
    wire pos_m14 = (abcd != m14);
    wire pos = pos_m0 & pos_m1 & pos_m4 & pos_m5 & pos_m6 & pos_m9 & pos_m10 & pos_m13 & pos_m14;
    assign out_pos = pos;

endmodule
