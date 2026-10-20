
module TopModule (
    input  in1,
    input  in2,
    output out
);

    wire nor_out;
    wire out;

    assign nor_out = in1 | in2;
    assign out = ~nor_out;

    
    assign out = ~ (in1 | in2);

endmodule
