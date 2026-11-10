
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dff[7:0];

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'b0;
            foreach (dff[i]) begin
                dff[i] <= 8'b0;
            end
        end else begin
            q <= d;
            foreach (dff[i]) begin
                dff[i] <= dff[i];
            end
        end
    end

    
    always @(posedge clk) begin
        foreach (dff[i]) begin
            if (dff[i] != d[i]) begin
                dff[i] <= d[i];
            end
        end
    end

endmodule
