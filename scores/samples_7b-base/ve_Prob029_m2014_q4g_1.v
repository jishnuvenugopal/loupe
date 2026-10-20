
module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;

    wire xnor_result;
    wire xor_result;

    
    assign xnor_result = (in1 == in2);

    
    assign xor_result = (xnor_result ^ in3);

    
    assign out = xor_result;
endmodule
