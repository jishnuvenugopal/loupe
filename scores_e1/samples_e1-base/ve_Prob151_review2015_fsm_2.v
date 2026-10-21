
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

    
    typedef enum {S0, S1, S2, S3, S4, S5, S6} state_t;
    state_t current_state, next_state;

    
    reg [3:0] shift_count;
    reg [3:0] count;

    
    reg pattern_detected;
    reg shift_ena asserted;
    reg counting asserted;
    reg done asserted;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            shift_count <= 0;
            count <= 0;
            pattern_detected <= 0;
            shift_ena asserted <= 0;
            counting asserted <= 0;
            done asserted <= 0;
        end else begin
            current_state <= next_state;
            shift_count <= shift_count + 1;
            count <= count + 1;

            
            if (data == 3'b1101) begin
                pattern_detected <= 1;
                next_state <= S1;
            end

            
            if (pattern_detected && shift_count == 3) begin
                next_state <= S2;
            end

            
            if (pattern_detected && shift_count == 3 && count == 3) begin
                next_state <= S3;
            end

            
            if (pattern_detected && shift_count == 3 && count == 3 && done_counting == 1) begin
                next_state <= S4;
            end

            
            if (pattern_detected && shift_count == 3 && count == 3 && done_counting == 1 && ack == 1) begin
                next_state <= S5;
            end

            
            if (pattern_detected && shift_count == 3 && count == 3 && done_counting == 1 && ack == 1 && reset == 1) begin
                next_state <= S6;
            end

            
            if (current_state == S1 && shift_count == 3 && count == 3 && done_counting == 1 && ack == 1) begin
                shift_ena asserted <= 1;
                next_state <= S2;
            end

            
            if (current_state == S2 && shift_count == 3 && count == 3 && done_counting == 1 && ack == 1) begin
                counting asserted <= 1;
                next_state <= S3;
            end

            
            if (current_state == S3 && shift_count == 3 && count == 3 && done_counting == 1 && ack == 1) begin
                done asserted <= 1;
                next_state <= S4;
            end

            
            if (current_state == S6) begin
                shift_count <= 0;
                count <= 0;
                pattern_detected <= 0;
                shift_ena asserted <= 0;
                counting asserted <= 0;
                done asserted <= 0;
                next_state <= S0;
            end
        end
    end

    
    assign shift_ena = shift_ena asserted;
    assign counting = counting asserted;
    assign done = done asserted;

endmodule
