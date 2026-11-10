
module TopModule (
    input clk,
    input in      (8 bits),
    input anyedge (8 bits),
    output reg [7:0] out
);

    
    typedef enum {IDLE, DETECT_EDGE} state_t;
    state_t state = IDLE;

    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (anyedge[0]) begin
                    state = DETECT_EDGE;
                    out[0] = 1'b0;
                end
            end
            DETECT_EDGE: begin
                if (in[0] != out[0]) begin
                    out[0] = 1'b1;
                    state = IDLE;
                end
            end
            default: begin
                state = IDLE;
            end
        endcase
    end

endmodule
