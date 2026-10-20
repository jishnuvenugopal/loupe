
module TopModule (
    input wire clk,
    input wire reset,
    input wire in,
    output reg done
);

    
    typedef enum {
        IDLE,
        START,
        DATA,
        STOP,
        ERROR
    } state_t;

    
    state_t current_state, next_state;

    
    reg [7:0] data_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            data_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            data_reg <= data_reg;
            done <= done;
        end
    end

    
    always @(current_state, in) begin
        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state <= START;
                end else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                if (in == 1'b1) begin
                    next_state <= DATA;
                end else begin
                    next_state <= IDLE;
                end
            end
            DATA: begin
                if (in == 1'b1) begin
                    next_state <= STOP;
                end else begin
                    data_reg <= {data_reg[6:0], in};
                    next_state <= DATA;
                end
            end
            STOP: begin
                if (in == 1'b0) begin
                    next_state <= IDLE;
                    done <= 1'b1;
                end else begin
                    next_state <= ERROR;
                end
            end
            ERROR: begin
                next_state <= IDLE;
                done <= 1'b0;
            end
        endcase
    end

endmodule
