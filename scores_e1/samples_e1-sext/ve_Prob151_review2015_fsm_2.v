
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

    
    typedef enum {idle, detect_pattern, shift_bits, counting, timeout, acknowledged} state_t;
    state_t state;

    
    reg [3:0] counter;

    
    reg [1:0] pattern_flag;
    reg [3:0] duration_flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            counter <= 4'b0000;
            pattern_flag <= 2'b00;
            duration_flag <= 4'b0000;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                idle: begin
                    if (data == 4'b1101) begin
                        state <= detect_pattern;
                        pattern_flag <= 2'b00;
                        duration_flag <= 4'b0000;
                    end
                end
                detect_pattern: begin
                    if (counter == 4'b0001) begin
                        state <= shift_bits;
                        pattern_flag <= 2'b01;
                        duration_flag <= 4'b0000;
                    end
                end
                shift_bits: begin
                    if (counter == 4'b0010) begin
                        state <= counting;
                        pattern_flag <= 2'b10;
                        duration_flag <= 4'b0000;
                    end
                end
                counting: begin
                    if (counter == 4'b0011) begin
                        state <= timeout;
                        pattern_flag <= 2'b11;
                        duration_flag <= 4'b0000;
                    end
                end
                timeout: begin
                    if (ack == 1'b1) begin
                        state <= acknowledged;
                    end
                end
                acknowledged: begin
                    if (reset == 1'b1) begin
                        state <= idle;
                        counter <= 4'b0000;
                        pattern_flag <= 2'b00;
                        duration_flag <= 4'b0000;
                        shift_ena <= 1'b0;
                        counting <= 1'b0;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        shift_ena = (state == detect_pattern) ? 1'b1 : 1'b0;
        counting = (state == counting) ? 1'b1 : 1'b0;
        done = (state == timeout) ? 1'b1 : 1'b0;
    end

endmodule
