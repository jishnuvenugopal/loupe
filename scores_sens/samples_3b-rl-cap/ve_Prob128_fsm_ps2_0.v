
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    
    reg done_reg;

    
    typedef enum {IDLE, WAIT_START, CAPTURE_BYTE1, CAPTURE_BYTE2, CAPTURE_BYTE3} fsm_state_t;
    fsm_state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            byte1   <= 8'b0;
            byte2   <= 8'b0;
            byte3   <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= WAIT_START;
                    else
                        state <= IDLE;
                end
                WAIT_START: begin
                    if (in[3])
                        state <= CAPTURE_BYTE1;
                    else
                        state <= WAIT_START;
                end
                CAPTURE_BYTE1: begin
                    byte1 <= in;
                    state <= CAPTURE_BYTE2;
                end
                CAPTURE_BYTE2: begin
                    byte2 <= in;
                    state <= CAPTURE_BYTE3;
                end
                CAPTURE_BYTE3: begin
                    byte3 <= in;
                    state <= IDLE;
                    done_reg <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign done = done_reg;

endmodule
