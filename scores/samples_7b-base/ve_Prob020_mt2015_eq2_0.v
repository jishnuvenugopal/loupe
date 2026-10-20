
module TopModule (input [1:0] A, input [1:0] B, output z);
    wire [1:0] xor_result;

    
    assign xor_result[0] = A[0] ^ B[0];
    assign xor_result[1] = A[1] ^ B[1];

    
    assign z = ~(|xor_result);
endmodule
