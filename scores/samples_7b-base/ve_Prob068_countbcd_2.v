
module TopModule (
    input clk,
    input reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

reg [3:0] cnt;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        cnt <= 4'b0000;
        q <= 16'b0000000000000000;
    end else begin
        cnt <= cnt + 1;
        if (cnt == 9) begin
            q[3:0] <= q[3:0] + 1;
            cnt <= 4'b0000;
            if (q[3:0] == 4'b1001) begin  
                ena[0] <= 1;
                q[7:4] <= q[7:4] + 1;
                if (q[7:4] == 4'b1001) begin  
                    ena[1] <= 1;
                    q[11:8] <= q[11:8] + 1;
                    if (q[11:8] == 4'b1001) begin  
                        ena[2] <= 1;
                        q[15:12] <= q[15:12] + 1;
                        if (q[15:12] == 4'b1001) begin  
                            ena[3] <= 1;
                        end
                    end
                end
            end
        end
        ena[0] <= 0;
        ena[1] <= 0;
        ena[2] <= 0;
        ena[3] <= 0;
    end
end

endmodule
