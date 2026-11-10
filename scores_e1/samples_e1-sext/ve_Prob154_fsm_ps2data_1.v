
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum {idle, searching, done} state_t;
    state_t state;

    
    reg [7:0] current_byte;
    reg [2:0] byte_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            current_byte <= 8'b0;
            byte_count <= 3'b0;
        end else begin
            case (state)
                idle: begin
                    if (in[3] == 1) begin
                        state <= searching;
                        current_byte <= in;
                        byte_count <= 3'b0;
                    end
                end
                searching: begin
                    current_byte <= current_byte << 1 | in[0];
                    byte_count <= byte_count + 1;
                    if (byte_count == 3) begin
                        state <= done;
                        out_bytes <= current_byte;
                    end
                end
                done: begin
                    
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule
