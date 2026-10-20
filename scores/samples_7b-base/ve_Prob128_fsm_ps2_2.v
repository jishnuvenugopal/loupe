
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum reg [1:0] {
        IDLE,
        BYTE1,
        BYTE2,
        BYTE3
    } state_t;

    state_t current_state, next_state;
    reg [2:0] byte_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == BYTE3)
                byte_count <= 0;
            else if (next_state == IDLE)
                byte_count <= 3;
            else
                byte_count <= byte_count - 1;
        end
    end

    
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                    byte_count = 2;
                end
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
        endcase
    end

    
    assign done = (current_state == BYTE3);

endmodule
