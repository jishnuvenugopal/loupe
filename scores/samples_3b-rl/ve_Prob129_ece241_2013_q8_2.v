
module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    
    typedef enum {S00, S01, S10} state_t;
    state_t state;

    
    always @(posedge clk) begin
        if (!aresetn) begin
            state <= S00;
            z <= 1'b0;
        end else begin
            case (state)
                S00: begin
                    if (x == 1'b1)
                        state <= S01;
                    else
                        state <= S00;
                end
                S01: begin
                    if (x == 1'b0)
                        state <= S10;
                    else
                        state <= S00;
                end
                S10: begin
                    if (x == 1'b1)
                        state <= S10;
                    else
                        state <= S00;
                    z <= 1'b1;
                end
                default: state <= S00;
            endcase
        end
    end

endmodule
