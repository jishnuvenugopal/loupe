
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg count[3:0],
    output reg counting,
    output reg done,
    input  ack
);

    
    typedef enum logic [2:0] {
        IDLE,
        START_SEARCH,
        READ_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;

    
    reg [3:0] delay;
    reg [3:0] remaining_time;
    reg [3:0] count_counter;
    reg [3:0] data_counter;
    reg [3:0] data_buffer;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            count <= 4'b0;
            counting <= 0;
            done <= 0;
            delay <= 4'b0;
            remaining_time <= 4'b0;
            count_counter <= 4'b0;
            data_counter <= 4'b0;
            data_buffer <= 4'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        next_state <= START_SEARCH;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                START_SEARCH: begin
                    next_state <= READ_DELAY;
                end

                READ_DELAY: begin
                    if (data_counter == 4'b0) begin
                        next_state <= COUNTING;
                    end else begin
                        data_buffer[data_counter] <= data;
                        data_counter <= data_counter - 1;
                        next_state <= READ_DELAY;
                    end
                end

                COUNTING: begin
                    if (count_counter == 4'b0) begin
                        next_state <= DONE;
                    end else begin
                        count_counter <= count_counter - 1;
                        remaining_time <= remaining_time - 1;
                        next_state <= COUNTING;
                    end
                end

                DONE: begin
                    if (ack) begin
                        next_state <= IDLE;
                    end else begin
                        next_state <= DONE;
                    end
                end
            endcase
        end
    end

    
    assign count = remaining_time;
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

endmodule
