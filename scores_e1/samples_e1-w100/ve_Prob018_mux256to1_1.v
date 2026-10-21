
module TopModule (
    input  [255:0] in,  
    input  [7:0]  sel,  
    output reg out   
);

    
    for (genvar i = 0;
 i < 8;
 i = i + 1) begin
        assign out = in[i];
    end

endmodule
