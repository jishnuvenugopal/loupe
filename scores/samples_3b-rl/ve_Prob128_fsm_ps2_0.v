
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    
    typedef enum {IDLE, WAIT_START, CAPTURE1, CAPTURE2, CAPTURE3} state_t;
    reg [3:0] state;

    
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            byte1   <= 8'b0;
            byte2   <= 8'b0;
            byte3   <= 8'b0;
            done    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= WAIT_START;
                    else
                        state <= IDLE;
                end
                WAIT_START: begin
                    if (in[3])
                        state <= CAPTURE1;
                    else
                        state <= WAIT_START;
                end
                CAPTURE1: begin
                    byte1 <= in;
                    state <= CAPTURE2;
                end
                CAPTURE2: begin
                    byte2 <= in;
                    state <= CAPTURE3;
                end
                CAPTURE3: begin
                    byte3 <= in;
                    state <= IDLE;
                    done   <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
