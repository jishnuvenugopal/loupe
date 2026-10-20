
module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg out_byte,
    output reg done
);

    
    typedef enum {IDLE, START, DATA, STOP} state_t;
    state_t current_state, next_state;

    
    reg [7:0] data;
    reg start_bit_detected;
    reg stop_bit_detected;
    reg byte_received;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            start_bit_detected <= 0;
            stop_bit_detected <= 0;
            byte_received <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START;
                end
            end
            START: begin
                if (in == 1) begin
                    next_state = DATA;
                end
            end
            DATA: begin
                if (in == 1) begin
                    next_state = DATA;
                end else begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 0) begin
                    next_state = IDLE;
                    byte_received <= 1;
                    out_byte <= data;
                    done <= 1;
                end else begin
                    next_state = STOP;
                end
            end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data <= 0;
        end else begin
            if (current_state == DATA) begin
                data <= {data[6:0], in};
            end
        end
    end

endmodule
