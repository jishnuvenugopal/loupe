
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dff[7:0];

    
    assign dff[0] = d[0];
    assign dff[1] = d[1];
    assign dff[2] = d[2];
    assign dff[3] = d[3];
    assign dff[4] = d[4];
    assign dff[5] = d[5];
    assign dff[6] = d[6];
    assign dff[7] = d[7];

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'b0;
        end else begin
            q <= dff;
        end
    end

endmodule
