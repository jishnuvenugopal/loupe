
module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out_bytes,
    output done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    state_t current_state, next_state;

    
    reg [2:0] state_reg;

    
    reg [7:0] byte_buffer [0:2];

    
    reg [1:0] byte_counter;

    
    reg [23:0] out_byte;

    
    reg [23:0] out_byte_reg;

    
    reg done_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            state_reg <= IDLE;
            byte_buffer <= 0;
            byte_counter <= 0;
            out_byte <= 0;
            out_byte_reg <= 0;
            done_reg <= 0;
        end else begin
            current_state <= next_state;
            state_reg <= current_state;
            byte_buffer <= byte_buffer;
            byte_counter <= byte_counter;
            out_byte <= out_byte;
            out_byte_reg <= out_byte;
            done_reg <= done;
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
                    byte_buffer[0] <= in;
                    byte_counter <= 1;
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE2: begin
                if (in[3]) begin
                    byte_buffer[1] <= in;
                    byte_counter <= 2;
                    next_state = BYTE3;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE3: begin
                if (in[3]) begin
                    byte_buffer[2] <= in;
                    byte_counter <= 3;
                    next_state = IDLE;
                    done_reg <= 1;
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_byte_reg <= 0;
        end else begin
            if (done_reg) begin
                out_byte_reg <= {byte_buffer[2], byte_buffer[1], byte_buffer[0]};
            end
        end
    end

    
    assign out_bytes = out_byte_reg;
    assign done = done_reg;

endmodule
