
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dff[7:0];

    
    assign dff[0] = 8'b0;
    assign dff[1] = 8'b0;
    assign dff[2] = 8'b0;
    assign dff[3] = 8'b0;
    assign dff[4] = 8'b0;
    assign dff[5] = 8'b0;
    assign dff[6] = 8'b0;
    assign dff[7] = 8'b0;

    
    always @(posedge clk) begin
        if (reset) begin
            
            dff[0] <= 8'b0;
            dff[1] <= 8'b0;
            dff[2] <= 8'b0;
            dff[3] <= 8'b0;
            dff[4] <= 8'b0;
            dff[5] <= 8'b0;
            dff[6] <= 8'b0;
            dff[7] <= 8'b0;
        end else begin
            
            dff[0] <= d[0];
            dff[1] <= d[1];
            dff[2] <= d[2];
            dff[3] <= d[3];
            dff[4] <= d[4];
            dff[5] <= d[5];
            dff[6] <= d[6];
            dff[7] <= d[7];
        end
    end

    
    assign q = dff[0];

endmodule
