
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    
    typedef enum {IDLE, RISING_EDGE} state_t;
    state_t state = IDLE;

    always @(posedge clk or negedge clk) begin
        if (clk == 1'b1) begin
            case (state)
                IDLE: begin
                    if (in[0] == 1'b0) begin
                        state = RISING_EDGE;
                    end
                end
                RISING_EDGE: begin
                    if (in[0] == 1'b1) begin
                        pedge[0] = 1'b1;
                        state = IDLE;
                    end
                end
            endcase
        end
    end

endmodule
