
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);


typedef enum {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3,
    DONE
} state_t;


state_t current_state, next_state;


reg [7:0] byte1, byte2, byte3;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        done <= 1'b0;
    end else begin
        current_state <= next_state;

        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state <= BYTE1;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE1: begin
                if (in[3]) begin
                    byte1 <= in;
                    next_state <= BYTE2;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE2: begin
                if (in[3]) begin
                    byte2 <= in;
                    next_state <= BYTE3;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE3: begin
                if (in[3]) begin
                    byte3 <= in;
                    next_state <= DONE;
                end else begin
                    next_state <= IDLE;
                end
            end
            DONE: begin
                next_state <= IDLE;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule
