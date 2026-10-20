
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;
    localparam S_IDLE = 2'd0;
    localparam S_GOT_1 = 2'd1;
    localparam S_GOT_2 = 2'd2;
    localparam S_DONE = 2'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done <= 0;
        end else begin
            done <= 0;
 
            case (state)
                S_IDLE: begin
                    if (in[3]) 
                        state <= S_GOT_1;
                end
                S_GOT_1: begin
                    state <= S_GOT_2;
                end
                S_GOT_2: begin
                    state <= S_DONE;
                end
                S_DONE: begin
                    done <= 1;
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
