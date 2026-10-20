
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

    
    localparam IDLE = 3'b000,
               DETECT_PATTERN = 3'b001,
               ASSERT_SHIFT_ENA = 3'b010,
               SET_COUNTING = 3'b011,
               WAIT_DONE_COUNTING = 3'b100,
               NOTIFY_USER = 3'b101,
               WAIT_ACK = 3'b110;

    
    reg [1:0] current_state, next_state;

    
    reg [1:0] pattern_bits;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = current_state;
        pattern_bits = {pattern_bits[0], data};
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                if (pattern_bits == 4'b1101) begin
                    next_state = DETECT_PATTERN;
                end
            end
            DETECT_PATTERN: begin
                next_state = ASSERT_SHIFT_ENA;
            end
            ASSERT_SHIFT_ENA: begin
                if (shift_ena_counter == 4'b1111) begin
                    next_state = SET_COUNTING;
                end
            end
            SET_COUNTING: begin
                counting = 1'b1;
            end
            WAIT_DONE_COUNTING: begin
                if (done_counting) begin
                    next_state = NOTIFY_USER;
                end
            end
            NOTIFY_USER: begin
                done = 1'b1;
            end
            WAIT_ACK: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    
    reg [3:0] shift_ena_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_ena_counter <= 4'b0000;
        end else if (current_state == ASSERT_SHIFT_ENA && shift_ena_counter < 4'b1111) begin
            shift_ena_counter <= shift_ena_counter + 1'b1;
            shift_ena <= 1'b1;
        end
    end

endmodule
