
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t current_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            z <= 0;
        end else begin
            case (current_state)
                A: begin
                    if (x == 0) begin
                        current_state <= A;
                        z <= 0;
                    end else begin
                        current_state <= B;
                        z <= 1;
                    end
                end
                B: begin
                    if (x == 0) begin
                        current_state <= B;
                        z <= 1;
                    end else begin
                        current_state <= A;
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule
