
module top_module(
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dffs [0:7];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0;
 i < 8;
 i = i + 1) begin
                dffs[i] <= 1'b0;
 
            end
            q <= 8'b00000000;
 
        end else begin
            dffs <= {dffs[6:0], d[0]};
 
            q <= dffs[7:0];
 
        end
    end

endmodule
