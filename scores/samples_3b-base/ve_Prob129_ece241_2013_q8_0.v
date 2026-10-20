
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    
    typedef enum { S0, S1, S2 } state_t;
    state_t current_state, next_state;

    
    reg [1:0] state_reg;

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
            state_reg <= S0;
            z <= 0;
        end else begin
            current_state <= next_state;
            state_reg <= current_state;
            z <= 0;
        end
    end

    
    always @(*) begin
        case (state_reg)
            S0: begin
                if (x == 1) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                if (x == 0) begin
                    next_state = S2;
                end else begin
                    next_state = S0;
                end
            end
            S2: begin
                if (x == 1) begin
                    next_state = S0;
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    
    always @(*) begin
        case (state_reg)
            S2: begin
                z = 1;
            end
            default: begin
                z = 0;
            end
        endcase
    end

endmodule
