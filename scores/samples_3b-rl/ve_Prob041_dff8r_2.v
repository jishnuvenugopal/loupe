
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff [7:0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0;
 i < 8;
 i = i + 1) begin
                dff[i] <= 8'b0;
            end
        end else begin
            for (i = 0;
 i < 8;
 i = i + 1) begin
                dff[i] <= d[i];
            end
        end
    end

    assign q = {dff[7], dff[6], dff[5], dff[4], dff[3], dff[2], dff[1], dff[0]};

endmodule
