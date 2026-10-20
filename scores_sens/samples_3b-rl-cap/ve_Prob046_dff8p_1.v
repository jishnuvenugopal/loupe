
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [7:0] d,
    output reg  [7:0] q
);

    
    reg [7:0] dffs;

    
    always @(negedge clk) begin
        if (reset) begin
            dffs <= 8'b110100;
        end else begin
            dffs <= d;
        end
    end

    
    always @(*) begin
        q = dffs;
    end

endmodule
