
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    wire feedback;
    localparam TAP_MASK = 32'h80200003;
 

    assign feedback = q[0];

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= (q >> 1) ^ ( {32{feedback}} & TAP_MASK );
    end
endmodule
