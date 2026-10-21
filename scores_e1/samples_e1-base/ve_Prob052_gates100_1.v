
module TopModule (
    input  [99:0] in,
    output reg [99:0] out_and,
    output reg [99:0] out_or,
    output reg [99:0] out_xor
);

    
    always @(posedge clk or negedge rst) begin
        out_and <= in & in;
    end

    
    always @(posedge clk or negedge rst) begin
        out_or <= in | in;
    end

    
    always @(posedge clk or negedge rst) begin
        out_xor <= in ^ in;
    end

endmodule
