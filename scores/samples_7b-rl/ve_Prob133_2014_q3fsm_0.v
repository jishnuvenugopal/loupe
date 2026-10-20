
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z = 0
);

    reg state;
 
    reg [1:0] count;
 
    reg [1:0] sum;
 

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            count <= 0;
            sum <= 0;
            z <= 0;
        end else begin
            z <= 0;
 

            if (state == 0) begin 
                if (s) begin
                    state <= 1;
                    count <= 0;
                    sum <= 0;
                end
            end else begin 
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
        end
    end

endmodule
