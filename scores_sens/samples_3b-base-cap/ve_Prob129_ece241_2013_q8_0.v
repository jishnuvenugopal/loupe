
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    
    typedef enum { S0, S1, S2 } state_t;
    state_t current_state, next_state;

    
    reg [1:0] state_reg;

    
    reg sequence_detected;

    
    initial begin
        current_state = S0;
        state_reg = 2'b00;
        sequence_detected = 0;
    end

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state = S0;
            state_reg = 2'b00;
            sequence_detected = 0;
        end else begin
            current_state <= next_state;
            state_reg <= {state_reg[0], current_state};
        end
    end

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            z <= 0;
        end else begin
            z <= sequence_detected;
        end
    end

    
    always @(*) begin
        case (current_state)
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

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            sequence_detected <= 0;
        end else begin
            if (current_state == S2 && x == 1) begin
                sequence_detected <= 1;
            end else begin
                sequence_detected <= 0;
            end
        end
    end

endmodule
