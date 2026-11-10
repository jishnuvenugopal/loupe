
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    reg [31:0] next_q;
    reg [31:0] taps = 32'h00000000;
 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 32'h1;
 
            next_q <= 32'h1;
 
        end else begin
            next_q <= q << 1;
 
            next_q = next_q ^ taps;
 
            q <= next_q;
 
        end
    end

endmodule
