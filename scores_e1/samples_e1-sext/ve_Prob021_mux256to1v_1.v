
module TopModule (
    input wire [1023:0] in,  
    input wire [7:0]   sel,  
    output reg [3:0]  out   
);

always @(*) begin
    
    int index = sel[3:0];
    
    
    out = in[index*4 : (index+1)*4];
end

endmodule
