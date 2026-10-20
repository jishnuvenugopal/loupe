
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    
    integer i;
    reg dff_q [7:0];

    
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0;
 i < 8;
 i = i + 1) begin
                dff_q[i] <= 1'b0;
            end
        end else begin
            for (i = 0;
 i < 8;
 i = i + 1) begin
                dff_q[i] <= d[i];
            end
        end
    end

    
    assign q = dff_q;

endmodule
