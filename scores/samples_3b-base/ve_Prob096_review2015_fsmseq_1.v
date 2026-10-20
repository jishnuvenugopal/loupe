
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);


typedef enum logic [2:0] {
    IDLE,
    SEARCH_1,
    SEARCH_0,
    SEARCH_1,
    SEARCH_1,
    FOUND
} state_t;


state_t current_state, next_state;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
    end
end


always @(*) begin
    case (current_state)
        IDLE: begin
            if (data) begin
                next_state = SEARCH_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEARCH_1: begin
            if (data) begin
                next_state = SEARCH_0;
            end else begin
                next_state = IDLE;
            end
        end
        SEARCH_0: begin
            if (data) begin
                next_state = SEARCH_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEARCH_1: begin
            if (data) begin
                next_state = SEARCH_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEARCH_1: begin
            if (data) begin
                next_state = FOUND;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
    endcase
end

endmodule
