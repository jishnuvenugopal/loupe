
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  [9:0] q
);

    reg [9:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 10'd0;
        else
            count <= count + 1;
    end

    assign q = count;

endmodule
