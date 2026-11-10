
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum {IDLE, DETECT, SHIFT, COUNT, DONE} state_t;
    state_t state = IDLE;

    
    reg [3:0] count = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state <= DETECT;
                        count <= 0;
                    end
                end
                DETECT: begin
                    count <= count + 1;
                    if (count == 4'b1101) begin
                        state <= SHIFT;
                    end
                end
                SHIFT: begin
                    shift_ena <= 1;
                    counting <= 1;
                    state <= COUNT;
                end
                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
