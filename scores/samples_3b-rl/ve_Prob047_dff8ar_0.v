
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dffs [7:0];

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            for (i = 0;
 i < 8;
 i = i + 1) begin
                dffs[i] <= 8'b0;
            end
            q <= 8'b0;
        end else begin
            
            for (i = 0;
 i < 8;
 i = i + 1) begin
                dffs[i] <= d[i];
            end
            
            q <= {dffs[7], dffs[6], dffs[5], dffs[4], dffs[3], dffs[2], dffs[1], dffs[0]};
        end
    end

endmodule
