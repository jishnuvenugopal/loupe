
module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3} FSM_state_t;
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            out_bytes <= 24'd0;
            done    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE1;
                    else
                        state <= IDLE;
                end
                BYTE1: begin
                    out_bytes[23:16] <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    out_bytes[15:8] <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    out_bytes[7:0] <= in;
                    done    <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
