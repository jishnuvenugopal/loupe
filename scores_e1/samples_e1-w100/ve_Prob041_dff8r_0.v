
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dff_reg [0:7];

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                dff_reg[i] <= 8'b0;
            end
        end else begin
            for (int i = 0;
 i < 8;
 i = i + 1) begin
                dff_reg[i] <= d[i];
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            if (dff_reg[i] != 8'b0) begin
                q[i] <= dff_reg[i];
            end
        end
    end

endmodule
