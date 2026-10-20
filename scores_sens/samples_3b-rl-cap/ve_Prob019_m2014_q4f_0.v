
module TopModule (
    input  in1,
    input  in2,
    output out
);

    
    wire in2_bubbled;
    assign in2_bubbled = in2 & 1'b1;

    
    assign out = in1 & in2_bubbled;

endmodule
