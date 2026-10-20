
module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,
        START_BIT,
        RECEIVE_DATA,
        STOP_BIT,
        WAIT_FOR_RESTART
    } state_t;

    state_t state, next_state;

    reg [7:0] data_reg;
    integer bit_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
            data_reg <= 0;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                if (bit_count == 0) begin
                    data_reg = 0;
                end
                bit_count <= bit_count + 1;
                if (bit_count == 9) begin
                    next_state = RECEIVE_DATA;
                end
            end
            RECEIVE_DATA: begin
                data_reg = data_reg << 1;
                data_reg[0] = in;
                if (bit_count < 9) begin
                    bit_count <= bit_count + 1;
                end else begin
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1) begin
                    next_state = WAIT_FOR_RESTART;
                    done <= 1;
                end
            end
            WAIT_FOR_RESTART: begin
                if (in == 0) begin
                    next_state = START_BIT;
                end
            end
        endcase
    end

endmodule
