
module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);

    
    integer i;
    for (i = 0;
 i < 25;
 i = i + 1) begin
        
        out[i] = ~(~a ^ (inputs[i+1] << i));
    end

endmodule
