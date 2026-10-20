
module TopModule (
    input  in  [1023:0], 
    input  sel [  7:0], 
    output out [  3:0]  
);

    
    generate
        for (genvar i = 0;
 i < 256;
 i++) begin
            assign out[i] = in[i*4 +: 4];
        end
    endgenerate

endmodule
