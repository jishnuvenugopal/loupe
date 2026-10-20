
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'h34;
        else
            q <= d;
    end

endmodule
