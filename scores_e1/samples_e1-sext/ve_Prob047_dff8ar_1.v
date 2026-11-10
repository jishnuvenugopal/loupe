
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dff_0, dff_1, dff_2, dff_3, dff_4, dff_5, dff_6, dff_7;

    
    initial begin
        q <= 8'b0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            dff_0 <= 8'b0;
            dff_1 <= 8'b0;
            dff_2 <= 8'b0;
            dff_3 <= 8'b0;
            dff_4 <= 8'b0;
            dff_5 <= 8'b0;
            dff_6 <= 8'b0;
            dff_7 <= 8'b0;
        end else begin
            
            dff_0 <= d[0];
            dff_1 <= d[1];
            dff_2 <= d[2];
            dff_3 <= d[3];
            dff_4 <= d[4];
            dff_5 <= d[5];
            dff_6 <= d[6];
            dff_7 <= d[7];
        end
    end

endmodule
