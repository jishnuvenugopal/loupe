
module TopModule (
    input wire [3:0] x,  
    output reg f      
);

    
    assign f = (x[1] == 0 && x[2] == 0) ? 1'b0 : 1'b1;

endmodule
