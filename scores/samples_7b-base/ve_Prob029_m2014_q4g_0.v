
module TopModule(in1, in2, in3, out);
    input  in1, in2, in3;
    output out;

    wire intermediate;

    
    assign intermediate = (in1 == in2);

    
    assign out = intermediate ^ in3;

endmodule
