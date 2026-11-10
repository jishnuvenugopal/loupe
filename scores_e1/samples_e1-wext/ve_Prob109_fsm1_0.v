
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    typedef enum {A, B} state_t;

    
    state_t state = B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: begin
                    if (in == 1'b0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    if (in == 1'b0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
            endcase
        end
    end

    assign out = state;

endmodule
