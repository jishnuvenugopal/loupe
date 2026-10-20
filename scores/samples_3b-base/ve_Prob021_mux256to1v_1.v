
module TopModule (
    input  [1023:0] in,  
    input  [  7:0] sel,  
    output [  3:0] out   
);

    
    reg [  3:0] mask [0:255];
    generate
        for (genvar i = 0;
 i < 256;
 i++) begin
            assign mask[i] = {i[3:0], i[3:0], i[3:0], i[3:0]};
        end
    endgenerate

    
    assign out = in & mask[sel];

endmodule
