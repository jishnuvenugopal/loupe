
module TopModule (
    input wire clk,
    input wire reset,
    input wire data,
    input wire done_counting,
    input wire ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum {idle, detect_pattern, shift_bits, counting, timeout, acknowledged} state_t;
    state_t state = idle;

    
    reg [3:0] duration;
    reg [3:0] countdown;

    
    reg detect_pattern_flag;
    reg shift_bits_flag;
    reg counting_flag;
    reg timeout_flag;
    reg acknowledged_flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = idle;
            detect_pattern_flag = 0;
            shift_bits_flag = 0;
            counting_flag = 0;
            timeout_flag = 0;
            acknowledged_flag = 0;
            duration = 0;
            countdown = 0;
        end else begin
            case (state)
                idle: begin
                    if (data == 4'b1101) begin
                        detect_pattern_flag = 1;
                        state = detect_pattern;
                    end
                end
                detect_pattern: begin
                    if (detect_pattern_flag && data == 4'b1101) begin
                        state = shift_bits;
                    end else begin
                        detect_pattern_flag = 0;
                        state = idle;
                    end
                end
                shift_bits: begin
                    if (shift_bits_flag && data == 4'b1101) begin
                        duration = duration + 1;
                        state = counting;
                    end else begin
                        shift_bits_flag = 0;
                        state = idle;
                    end
                end
                counting: begin
                    if (countdown == 0) begin
                        timeout_flag = 1;
                        state = timeout;
                    end else begin
                        countdown = countdown - 1;
                    end
                end
                timeout: begin
                    if (timeout_flag && done_counting) begin
                        acknowledged_flag = 1;
                        state = acknowledged;
                    end else begin
                        timeout_flag = 0;
                        state = idle;
                    end
                end
                acknowledged: begin
                    if (acknowledged_flag && ack) begin
                        state = idle;
                    end else begin
                        acknowledged_flag = 0;
                    end
                end
            endcase
        end
    end

    
    assign shift_ena = state == shift_bits;
    assign counting = state == counting;
    assign done = state == timeout;

endmodule
