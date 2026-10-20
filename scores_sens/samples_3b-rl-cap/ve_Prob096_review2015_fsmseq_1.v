
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    
    reg [3:0] state;

    
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state  <= 4'b0000;
            found  <= 1'b0;
            start_shifting <= 1'b0;
        end else begin
            
            state <= {state[2:0], data};

            
            if (state == 4'b1101) begin
                found <= 1'b1;
            end

            
            if (found) begin
                start_shifting <= 1'b1;
            end else begin
                start_shifting <= 1'b0;
            end
        end
    end

endmodule
