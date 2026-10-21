
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {IDLE, WAITING_FOR_1, WAITING_FOR_0} state_t;

    
    state_t state;

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (x == 1) begin
                        state <= WAITING_FOR_1;
                    end
                end
                WAITING_FOR_1: begin
                    if (x == 0) begin
                        state <= WAITING_FOR_0;
                    end
                end
                WAITING_FOR_0: begin
                    if (x == 1) begin
                        state <= WAITING_FOR_1;
                    end
                    else if (x == 0) begin
                        state <= IDLE;
                        z <= 1;
                    end
                end
            endcase
        end
    end

endmodule
