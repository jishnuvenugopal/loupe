
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dffs [7:0];

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0;
 i < 8;
 i++) begin
                dffs[i] <= 8'b0;
            end
        end else begin
            for (int i = 0;
 i < 8;
 i++) begin
                dffs[i] <= d[i];
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i++) begin
            if (dffs[i] == 8'b1) begin
                dffs[i] <= 8'b0;
            end
        end
    end

    
    assign q = dffs;

endmodule
