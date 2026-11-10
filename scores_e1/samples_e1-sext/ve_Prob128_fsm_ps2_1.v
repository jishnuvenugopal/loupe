
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, RECEIVING, DONE} state_t;
    state_t state;

    
    reg [7:0] byte_count;
    reg [7:0] byte_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 8'b0;
            byte_index <= 8'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= RECEIVING;
                        byte_count <= 8'b0;
                        byte_index <= 8'b0;
                    end
                end
                RECEIVING: begin
                    byte_count <= byte_count + 1'b1;
                    if (byte_count == 3) begin
                        state <= DONE;
                        done <= 1'b1;
                    end
                end
                DONE: begin
                    
                end
            endcase
        end
    end

endmodule
