
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg state;
    reg [1:0] cnt;
    reg [2:0] w_sum;

    localparam S_A = 0, S_B = 1;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_A;
            cnt <= 0;
            w_sum <= 0;
            z <= 0;
        end else begin
            case (state)
                S_A: begin
                    z <= 0;
                    if (s) begin
                        state <= S_B;
                        cnt <= 0;
                        w_sum <= 0;
                    end
                end
                S_B: begin
                    if (cnt < 3) begin
                        w_sum <= w_sum + w;
                        cnt <= cnt + 1;
                    end else begin
                        z <= (w_sum == 2);
                        cnt <= 0;
                        w_sum <= 0;
                        
                    end
                end
            endcase
        end
    end

endmodule
