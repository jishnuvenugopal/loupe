
module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    
    typedef enum {B, A} state_t;

    
    state_t state;

    
    always @(*) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= B;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 1'b0;
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
                A: begin
                    if (in == 1'b0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
            endcase
            out <= state;
        end
    end

endmodule
