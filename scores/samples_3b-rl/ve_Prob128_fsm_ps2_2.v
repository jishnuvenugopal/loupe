
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [7:0] in,
    output reg  done
);

    
    typedef enum {WAIT_START, CAPTURE_IN1, CAPTURE_IN2, CAPTURE_IN3} FSM_state_t;
    reg [1:0] state;

    
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;

    always @(posedge clk) begin
        if (reset) begin
            state   <= 2'b00;
            in1     <= 8'b0;
            in2     <= 8'b0;
            in3     <= 8'b0;
            done    <= 1'b0;
        end else begin
            case (state)
                WAIT_START: begin
                    if (in[3]) begin
                        state   <= CAPTURE_IN1;
                        in1     <= in;
                    end else begin
                        state   <= WAIT_START;
                    end
                end
                CAPTURE_IN1: begin
                    state   <= CAPTURE_IN2;
                    in2     <= in;
                end
                CAPTURE_IN2: begin
                    state   <= CAPTURE_IN3;
                    in3     <= in;
                end
                CAPTURE_IN3: begin
                    state   <= WAIT_START;
                    done    <= 1'b1;
                end
                default: begin
                    state   <= WAIT_START;
                    in1     <= 8'b0;
                    in2     <= 8'b0;
                    in3     <= 8'b0;
                    done    <= 1'b0;
                end
            endcase
        end
    end

endmodule
