
module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    state_t current_state, next_state;

    
    reg [7:0] current_byte;

    
    reg [23:0] output_bytes;

    
    reg done_reg;

    
    reg [2:0] byte_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            current_byte <= 8'b0;
            output_bytes <= 24'b0;
            done_reg <= 1'b0;
            byte_count <= 3'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        current_byte <= in;
                        next_state <= BYTE1;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE1: begin
                    current_byte <= in;
                    next_state <= BYTE2;
                end
                BYTE2: begin
                    current_byte <= in;
                    next_state <= BYTE3;
                end
                BYTE3: begin
                    current_byte <= in;
                    output_bytes[23:16] <= current_byte;
                    output_bytes[15:8] <= current_byte;
                    output_bytes[7:0] <= current_byte;
                    done_reg <= 1'b1;
                    next_state <= IDLE;
                end
            endcase
        end
    end

    
    assign done = done_reg;

endmodule
