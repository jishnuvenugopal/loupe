
module TopModule (
    input clk,
    input areset,
    input d,
    output q
);

    
    reg [7:0] dffs [0:7];

    
    always @(posedge areset or posedge clk) begin
        if (arst) begin
            for (int i = 0;
 i < 8;
 i++) begin
                dffs[i] <= 8'b0;
            end
        end else if (clk) begin
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
            q[i] <= dffs[i];
        end
    end

endmodule
