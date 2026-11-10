
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    typedef enum {B, A} state_t;

    
    state_t state = B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                B: begin
                    if (in == 1) begin
                        state <= A;
                    end
                end
                A: begin
                    if (in == 0) begin
                        state <= B;
                    end
                end
            endcase
        end
    end

    assign out = state;

endmodule
