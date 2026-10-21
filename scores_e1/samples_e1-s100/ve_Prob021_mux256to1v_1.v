
module TopModule (
    input  [1023:0] in,  
    input  [7:0]   sel,  
    output [3:0]  out   
);

    
    reg [1023:0] input_vector;

    
    reg [3:0] output_vector;

    
    assign input_vector = in;

    
    always @(*) begin
        case (sel)
            8'b0000: output_vector = input_vector[3:0];
            8'b0001: output_vector = input_vector[7:4];
            8'b0010: output_vector = input_vector[11:8];
            8'b0011: output_vector = input_vector[15:12];
            8'b0100: output_vector = input_vector[19:16];
            8'b0101: output_vector = input_vector[23:20];
            8'b0110: output_vector = input_vector[27:24];
            8'b0111: output_vector = input_vector[31:28];
            8'b1000: output_vector = input_vector[35:32];
            8'b1001: output_vector = input_vector[39:36];
            8'b1010: output_vector = input_vector[43:40];
            8'b1011: output_vector = input_vector[47:44];
            8'b1100: output_vector = input_vector[51:48];
            8'b1101: output_vector = input_vector[55:52];
            8'b1110: output_vector = input_vector[59:56];
            8'b1111: output_vector = input_vector[63:60];
        endcase
    end

    
    assign out = output_vector;

endmodule
