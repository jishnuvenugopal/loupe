
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {idle, sequence1, sequence2, sequence3} state_t;

    
    state_t state = idle;

    
    always @(posedge clk or posedge aresetn) begin
        if (aresetn) begin
            state <= idle;
            z <= 0;
        end else begin
            case (state)
                idle:
                    if (x == 1) begin
                        state <= sequence1;
                        z <= 0;
                    end
                    else begin
                        state <= idle;
                        z <= 0;
                    end
                sequence1:
                    if (x == 0) begin
                        state <= sequence2;
                        z <= 0;
                    end
                    else begin
                        state <= idle;
                        z <= 0;
                    end
                sequence2:
                    if (x == 1) begin
                        state <= sequence3;
                        z <= 0;
                    end
                    else begin
                        state <= idle;
                        z <= 0;
                    end
                sequence3:
                    if (x == 0) begin
                        state <= idle;
                        z <= 1;
                    end
                    else begin
                        state <= idle;
                        z <= 0;
                    end
            endcase
        end
    end

endmodule
