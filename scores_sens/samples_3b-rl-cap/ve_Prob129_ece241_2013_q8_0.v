
module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    
    typedef enum {S0, S1, S2} state_t;
    state_t state;

    
    reg z_reg;

    
    assign z = z_reg;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state   <= S0;
            z_reg   <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x)
                        state <= S1;
                    else
                        state <= S0;
                    z_reg <= 1'b0;
                end
                S1: begin
                    if (!x)
                        state <= S2;
                    else
                        state <= S0;
                    z_reg <= 1'b0;
                end
                S2: begin
                    if (x)
                        state <= S0;
                    else
                        z_reg <= 1'b1;
                    else
                        state <= S1;
                    z_reg <= 1'b0;
                end
                default: begin
                    state <= S0;
                    z_reg <= 1'b0;
                end
            endcase
        end
    end

endmodule
