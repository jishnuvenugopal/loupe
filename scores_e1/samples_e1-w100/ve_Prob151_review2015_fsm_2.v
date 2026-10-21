
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

    
    typedef enum {Reset, DetectPattern, ShiftBits, WaitCounting, NotifyUser, WaitAck} state_t;
    state_t state = Reset;

    
    reg [3:0] counter = 0;

    
    reg [1:0] pattern_flag = 0;
    reg [3:0] shift_bits = 0;
    reg [1:0] user_ack_flag = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Reset;
            counter <= 0;
            pattern_flag <= 0;
            shift_bits <= 0;
            user_ack_flag <= 0;
        end else begin
            case (state)
                Reset: begin
                    if (data == 3'b1101) begin
                        state <= DetectPattern;
                        pattern_flag <= 1;
                    end
                end
                DetectPattern: begin
                    if (data == 3'b1101) begin
                        pattern_flag <= 1;
                    end else if (data != 3'b1101) begin
                        pattern_flag <= 0;
                    end
                end
                ShiftBits: begin
                    if (pattern_flag == 1) begin
                        shift_bits <= shift_bits + 1;
                        if (shift_bits == 4) begin
                            state <= WaitCounting;
                        end
                    end
                end
                WaitCounting: begin
                    if (done_counting == 1) begin
                        state <= NotifyUser;
                    end
                end
                NotifyUser: begin
                    if (user_ack_flag == 1) begin
                        state <= WaitAck;
                    end
                end
                WaitAck: begin
                    if (ack == 1) begin
                        state <= Reset;
                    end
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        case (state)
            DetectPattern: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            ShiftBits: begin
                shift_ena <= 1;
                counting <= 0;
                done <= 0;
            end
            WaitCounting: begin
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
            end
            NotifyUser: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
            end
            WaitAck: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end

endmodule
