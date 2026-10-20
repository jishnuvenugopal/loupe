
module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [9:0] data_out,
    output reg valid_out
);

    
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        RECEIVE_1 = 2'b01,
        RECEIVE_2 = 2'b10,
        RECEIVE_3 = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_reg;
    reg [9:0] accumulator;
    reg receive_complete;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            shift_reg <= 4'b0;
            accumulator <= 10'b0;
            receive_complete <= 0;
            data_out <= 10'b0;
            valid_out <= 0;
        end else begin
            current_state <= next_state;
            if (receive_complete) begin
                data_out <= accumulator;
                valid_out <= 1;
            end else begin
                valid_out <= 0;
            end
        end
    end

    
    always @(*) begin
        next_state = current_state;
        shift_reg = shift_reg;
        accumulator = accumulator;
        receive_complete = 0;

        case (current_state)
            IDLE: begin
                if (valid_in) begin
                    shift_reg[0] <= data_in;
                    accumulator[9:2] <= data_in[9:2];
                    next_state = RECEIVE_1;
                    receive_complete = 0;
                end
            end
            RECEIVE_1: begin
                if (valid_in) begin
                    shift_reg[1] <= data_in;
                    accumulator[1:0] <= data_in[1:0];
                    next_state = RECEIVE_2;
                    receive_complete = 0;
                end
            end
            RECEIVE_2: begin
                if (valid_in) begin
                    shift_reg[2] <= data_in;
                    next_state = RECEIVE_3;
                    receive_complete = 0;
                end
            end
            RECEIVE_3: begin
                if (valid_in) begin
                    shift_reg[3] <= data_in;
                    accumulator[9:0] <= accumulator + data_in;
                    next_state = IDLE;
                    receive_complete = 1;
                end
            end
        endcase
    end

endmodule
