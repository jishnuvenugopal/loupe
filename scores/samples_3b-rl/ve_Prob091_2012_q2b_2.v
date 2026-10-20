
module TopModule (
    input  wire [5:0] y,   
    input  wire       w,   
    output reg        Y1,  
    output reg        Y3   
);

always @(*) begin
    
    Y1 = y[1];
    Y3 = y[3];
end






endmodule
