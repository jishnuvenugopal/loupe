
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    typedef enum reg [1:0] {
        STATE_A,
        STATE_B,
        STATE_C,
        STATE_D
    } state_t;

    
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_A;
 
        end else begin
            current_state <= next_state;
 
        end
    end

    
    assign out = (current_state == STATE_D);
 

    
    always @(*) begin
        case (current_state)
            STATE_A: begin
                next_state = (in == 0) ? STATE_A : STATE_B;
            end
            STATE_B: begin
                next_state = (in == 0) ? STATE_B : STATE_C;
            end
            STATE_C: begin
                next_state = (in == 0) ? STATE_A : STATE_D;
            end
            STATE_D: begin
                next_state = (in == 0) ? STATE_C : STATE_B;
            end
            default: begin
                next_state = STATE_A;
 
            end
        endcase
    end

endmodule
