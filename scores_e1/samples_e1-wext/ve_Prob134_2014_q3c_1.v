
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {S0, S1} state_t;

    
    state_t state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            Y0 <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x == 1'b0) begin
                        state <= S0;
                        Y0 <= y[0];
                        z <= 1'b0;
                    end else begin
                        state <= S1;
                        Y0 <= y[1];
                        z <= 1'b0;
                    end
                end
                S1: begin
                    if (x == 1'b0) begin
                        state <= S1;
                        Y0 <= y[2];
                        z <= 1'b1;
                    end else begin
                        state <= S0;
                        Y0 <= y[0];
                        z <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
