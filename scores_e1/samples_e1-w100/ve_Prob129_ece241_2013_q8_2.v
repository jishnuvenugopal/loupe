
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {IDLE, WAIT1, WAIT2} state_t;

    
    state_t current_state = IDLE;

    
    always @(posedge clk or posedge aresetn) begin
        if (aresetn) begin
            current_state <= IDLE;
            z <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (x == 1) begin
                        current_state <= WAIT1;
                    end
                end
                WAIT1: begin
                    if (x == 0) begin
                        current_state <= WAIT2;
                    end
                end
                WAIT2: begin
                    if (x == 1) begin
                        current_state <= IDLE;
                        z <= 1;
                    end
                end
            endcase
        end
    end

endmodule
