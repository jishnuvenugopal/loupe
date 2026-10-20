
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    typedef enum reg [1:0] {
        STATE_B = 2'b00,
        STATE_A = 2'b01
    } state_t;

    
    state_t state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        case (state)
            STATE_B: begin
                out = 1;
                next_state = (in == 0) ? STATE_B : STATE_B;
            end
            STATE_A: begin
                out = 0;
                next_state = (in == 0) ? STATE_B : STATE_A;
            end
            default: begin
                
                out = 1;
                next_state = STATE_B;
            end
        endcase
    end

endmodule
