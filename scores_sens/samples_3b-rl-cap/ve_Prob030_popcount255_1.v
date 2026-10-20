
module TopModule (
    input  wire [254:0] in,
    output reg  [7:0]   out
);

    
    wire [254:0] sum;

    
    assign sum = in + 255'b0;

    
    assign out = sum[7:0];

endmodule
