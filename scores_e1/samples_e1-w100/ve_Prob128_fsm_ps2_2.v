
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {idle, searching, message_start, message_complete} state_t;
    state_t state;

    
    reg [7:0] byte_count;
    reg [1:0] byte_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            byte_count <= 0;
            byte_index <= 0;
            done <= 0;
        end else begin
            case (state)
                idle:
                    if (in[3] == 1) begin
                        state <= searching;
                        byte_count <= 0;
                        byte_index <= 0;
                    end
                searching:
                    if (in[3] == 1) begin
                        state <= message_start;
                        byte_count <= 0;
                        byte_index <= 0;
                    end
                message_start:
                    if (byte_count == 0) begin
                        byte_count <= 1;
                        byte_index <= 0;
                    end else if (byte_count == 1) begin
                        byte_count <= 2;
                        byte_index <= 0;
                    end else if (byte_count == 2) begin
                        byte_count <= 0;
                        byte_index <= 1;
                    end else if (byte_count == 3) begin
                        byte_count <= 0;
                        byte_index <= 2;
                        done <= 1;
                    end
                message_complete:
                    
                    break
            endcase
        end
    end

endmodule
