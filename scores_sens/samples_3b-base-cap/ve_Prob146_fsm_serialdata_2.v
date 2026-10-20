
module TopModule (
    input wire clk,
    input wire in,
    input wire reset,
    output reg [7:0] out_byte,
    output reg done
);

    
    typedef enum {IDLE, START, DATA, STOP} state_t;
    state_t current_state, next_state;

    
    reg [7:0] data_register;

    
    reg [7:0] current_byte;

    
    reg [3:0] bit_position;

    
    reg expected_stop;

    
    initial begin
        current_state = IDLE;
        done = 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            data_register <= 8'b0;
            current_byte <= 8'b0;
            bit_position <= 4'b0;
            expected_stop <= 1'b0;
        end else begin
            current_state <= next_state;

            
            case (current_state)
                IDLE: begin
                    if (in == 0) begin
                        next_state = START;
                    end else begin
                        next_state = IDLE;
                    end
                end
                START: begin
                    if (in == 1) begin
                        next_state = DATA;
                    end else begin
                        next_state = START;
                    end
                end
                DATA: begin
                    if (in == 1) begin
                        current_byte[bit_position] <= in;
                        bit_position <= bit_position + 1;
                        if (bit_position == 7) begin
                            next_state = STOP;
                        end else begin
                            next_state = DATA;
                        end
                    end else begin
                        next_state = DATA;
                    end
                end
                STOP: begin
                    if (in == 1) begin
                        expected_stop <= 1'b1;
                        next_state = STOP;
                    end else if (in == 0) begin
                        if (expected_stop) begin
                            done <= 1;
                            next_state = IDLE;
                        end else begin
                            next_state = STOP;
                        end
                    end else begin
                        next_state = STOP;
                    end
                end
            endcase

            
            if (current_state == DATA) begin
                data_register <= current_byte;
            end
        end
    end

    
    assign out_byte = done ? data_register : 8'bZZZZZZZZ;

endmodule
