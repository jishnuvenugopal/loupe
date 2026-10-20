
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg state;
 
    reg [1:0] count;
 
    reg [1:0] sum;
 

    parameter A = 0;
    parameter B = 1;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 0;
            sum <= 0;
            z <= 0;
        end else begin
            z <= 0;
 
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        count <= 0;
                        sum <= 0;
                    end
                end
                B: begin
                    if (count < 3) begin
                        sum <= sum + w;
                        count <= count + 1;
                    end else begin
                        
                        if (sum == 2)
                            z <= 1;
                        
                        sum <= 0;
                        count <= 0;
                    end
                end
            endcase
        end
    end

endmodule
