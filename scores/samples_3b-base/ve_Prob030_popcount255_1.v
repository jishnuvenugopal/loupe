
module TopModule (
    input  [255:0] in,
    output [7:0] out
);

    
    reg [7:0] count0, count1, count2, count3, count4, count5, count6;

    
    assign count0 = in[7:0];
    assign count1 = in[14:7];
    assign count2 = in[21:14];
    assign count3 = in[28:21];
    assign count4 = in[35:28];
    assign count5 = in[42:35];
    assign count6 = in[49:42];

    
    assign out = count0 + count1 + count2 + count3 + count4 + count5 + count6;

endmodule
