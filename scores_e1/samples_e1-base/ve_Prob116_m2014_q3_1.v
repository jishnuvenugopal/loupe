
module TopModule (
    input wire [3:0] x,
    output reg f
);

    
    assign f = (x[1] == 0) && (x[2] == 0) && (x[3] == 1);

endmodule
