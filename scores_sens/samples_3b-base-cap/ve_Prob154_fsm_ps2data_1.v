
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum logic [2:0] {
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
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == BYTE3) begin
                out_bytes <= {byte3, byte2, byte1};
                done <= 1'b1;
            end else if (current_state == DONE) begin
                done <= 1'b0;
            end
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
                    next_state = BYTE3;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE3: begin
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

endmodule
