
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, RECEIVING} state_t;
    state_t state = IDLE;

    
    reg [7:0] received_bytes;
    reg [1:0] received_bytes_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            received_bytes <= 8'b0;
            received_bytes_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    
                    if (in[3] == 1) begin
                        state <= START;
                        received_bytes = in;
                        received_bytes_count = 2'b0;
                    end
                end
                START: begin
                    
                    if (received_bytes_count == 0) begin
                        received_bytes = in;
                        received_bytes_count = 1'b1;
                    end else if (received_bytes_count == 1) begin
                        received_bytes = {received_bytes[7], in[2], in[3]};
                        received_bytes_count = 2'b0;
                        if (received_bytes == 0x03) begin
                            done <= 1'b1;
                        end
                    end
                end
                RECEIVING: begin
                    
                    if (received_bytes_count == 0) begin
                        received_bytes = in;
                        received_bytes_count = 1'b1;
                    end else if (received_bytes_count == 1) begin
                        received_bytes = {received_bytes[7], in[2], in[3]};
                        received_bytes_count = 2'b0;
                        if (received_bytes == 0x03) begin
                            done <= 1'b1;
                        end
                    end
                end
            endcase
        end
    end

endmodule
