
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {IDLE, FRAME_START, FRAME_END, ERROR} state_t;
    state_t state = IDLE;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1) begin
                        state <= FRAME_START;
                    end
                end
                FRAME_START: begin
                    if (in == 1) begin
                        state <= FRAME_END;
                    end else if (in == 0) begin
                        state <= FRAME_START;
                    end
                end
                FRAME_END: begin
                    if (in == 1) begin
                        state <= ERROR;
                    end else if (in == 0) begin
                        state <= FRAME_END;
                    end
                end
                ERROR: begin
                    if (in == 1) begin
                        state <= ERROR;
                    end else if (in == 0) begin
                        state <= IDLE;
                    end
                end
            endcase

            
            case (state)
                IDLE: disc <= 0;
                FRAME_START: disc <= 0;
                FRAME_END: flag <= 1;
                ERROR: err <= 1;
            endcase
        end
    end

endmodule
