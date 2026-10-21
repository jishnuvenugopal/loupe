
module TopModule (
    input  [99:0] in,
    output reg [99:0] out_and,
    output reg [99:0] out_or,
    output reg [99:0] out_xor
);

    
    always @(posedge in) begin
        out_and <= in;
    end

    
    always @(posedge in) begin
        out_or <= in;
    end

    
    always @(posedge in) begin
        out_xor <= in;
    end

endmodule
