
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dff [7:0];

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                dff[i] <= 8'b0;
            end
        end else begin
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                dff[i] <= d[i];
            end
        end
    end

    
    assign q = dff;

endmodule
