
module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    
    reg [2:0] count;

    
    always @(posedge in) begin
        count[0] <= count[0] + in[0];
        count[1] <= count[1] + in[1];
        count[2] <= count[2] + in[2];
    end

    
    always @(posedge count) begin
        out <= count[0] + count[1];
    end

endmodule
