
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done
);


typedef enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    DONE
} state_t;

state_t current_state, next_state;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end


always @(*) begin
    case (current_state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            if (in[3]) begin
                next_state = BYTE2;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE2: begin
            if (in[3]) begin
                next_state = DONE;
            end else begin
                next_state = IDLE;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end


assign done = (current_state == DONE);

endmodule
