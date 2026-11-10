
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {State0, State1, State2, State3, State4} state_t;

    
    state_t state = State0;

    
    always @(posedge clk or negedge aresetn) begin
        if (!arstn) begin
            state <= State0;
            z <= 0;
        end else begin
            case (state)
                State0: begin
                    if (x == 1) begin
                        state <= State1;
                    end
                end
                State1: begin
                    if (x == 0) begin
                        state <= State2;
                    end
                end
                State2: begin
                    if (x == 1) begin
                        state <= State3;
                    end
                end
                State3: begin
                    if (x == 0) begin
                        state <= State4;
                    end
                end
                State4: begin
                    z <= 1;
                    state <= State0;
                end
            endcase
        end
    end

endmodule
