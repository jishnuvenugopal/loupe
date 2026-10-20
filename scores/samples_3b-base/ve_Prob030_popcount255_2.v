
module TopModule (
    input  [255:0] in,  
    output [ 7:0] out   
);

    
    reg [255:0] carry;
  

    
    genvar i;
    generate
        for (i = 0;
 i < 255;
 i = i + 1) begin
            
            assign carry[i+1] = in[i] + carry[i];
        end
    endgenerate

    
    assign out = carry[247:240];

endmodule
