
module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    
    typedef enum {IDLE, ACCUMULATE} state_t;
    state_t current_state, next_state;

    
    reg [3:0] input_count;

    
    reg [9:0] sum;

    
    reg [7:0] last_input;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            input_count <= 0;
            sum <= 0;
            last_input <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        next_state <= ACCUMULATE;
                        input_count <= 1;
                        sum <= data_in;
                        last_input <= data_in;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                ACCUMULATE: begin
                    if (valid_in) begin
                        next_state <= ACCUMULATE;
                        input_count <= input_count + 1;
                        sum <= sum + data_in;
                        last_input <= data_in;
                    end else begin
                        next_state <= IDLE;
                        valid_out <= 1;
                        data_out <= sum;
                    end
                end
            endcase
        end
    end

endmodule
