
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);


typedef enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;


state_t current_state, next_state;


logic [7:0] data;


logic stop_bit_detected;


logic [3:0] bit_counter;


logic [3:0] byte_counter;


logic done_flag;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        data <= 8'b0;
        stop_bit_detected <= 0;
        bit_counter <= 0;
        byte_counter <= 0;
        done_flag <= 0;
    end else begin
        current_state <= next_state;

        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state <= START;
                    bit_counter <= 0;
                end else begin
                    next_state <= IDLE;
                end
            end

            START: begin
                if (in == 1'b1) begin
                    next_state <= DATA;
                    bit_counter <= 0;
                end else begin
                    next_state <= START;
                end
            end

            DATA: begin
                if (bit_counter < 8) begin
                    data[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;
                    next_state <= DATA;
                end else begin
                    next_state <= STOP;
                end
            end

            STOP: begin
                if (in == 1'b1) begin
                    next_state <= IDLE;
                    byte_counter <= byte_counter + 1;
                    done_flag <= 1;
                end else begin
                    next_state <= STOP;
                end
            end
        endcase
    end
end


assign done = done_flag;

endmodule
