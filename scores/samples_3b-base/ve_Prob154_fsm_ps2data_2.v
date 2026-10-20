
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
            current_byte <= 8'b00000000;
            output_bytes <= 24'b0000000000000000;
            done_reg <= 1'b0;
            byte_count <= 3'b000;
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
                    if (in[3]) begin
                        current_byte <= in;
                        next_state <= BYTE2;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE2: begin
                    if (in[3]) begin
                        current_byte <= in;
                        next_state <= BYTE3;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE3: begin
                    if (in[3]) begin
                        current_byte <= in;
                        output_bytes[23:16] <= current_byte;
                        byte_count <= byte_count + 1'b1;
                        if (byte_count == 3'b111) begin
                            done_reg <= 1'b1;
                            next_state <= IDLE;
                        end else begin
                            next_state <= BYTE1;
                        end
                    end else begin
                        next_state <= IDLE;
                    end
                end
            endcase
        end
    end

    
    assign done = done_reg;

    
    assign out_bytes = output_bytes;

endmodule
