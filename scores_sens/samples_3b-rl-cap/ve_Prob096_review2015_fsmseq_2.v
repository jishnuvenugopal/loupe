
module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0;
            start_shifting <= 1'b0;
        end else begin
            
            state <= {state[2:0], data};
            
            if (state == 4'b1101) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule
