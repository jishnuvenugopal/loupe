
module TopModule(in1, in2, out);
    input in1, in2;
    output out;

    wire xor_out;
    wire not_out;

    xor (xor_out, in1, in2);
  
    not (out, xor_out);
        

endmodule
