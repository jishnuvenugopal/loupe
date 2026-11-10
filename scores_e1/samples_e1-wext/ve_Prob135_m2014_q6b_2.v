
module TopModule (
    input wire [2:0] y,
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t current_state = A;
    state_t next_state;

    
    reg [2:0] y_reg;
    reg [2:0] w_reg;

    
    always @(posedge w) begin
        if (w) begin
            next_state = current_state;
        end else begin
            next_state = y_reg;
        end
    end

    
    always @(posedge y) begin
        case (current_state)
            A: begin
                if (w) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (w) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            C: begin
                if (w) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (w) begin
                    next_state = F;
                end else begin
                    next_state = A;
                end
            end
            E: begin
                if (w) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            F: begin
                if (w) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            default: next_state = A;
 
        endcase
    end

    
    always @(*) begin
        if (current_state == A) begin
            Y1 = 0;
        end else if (current_state == B) begin
            Y1 = 0;
        end else if (current_state == C) begin
            Y1 = 1;
        end else if (current_state == D) begin
            Y1 = 0;
        end else if (current_state == E) begin
            Y1 = 0;
        end else if (current_state == F) begin
            Y1 = 1;
        end
    end

endmodule
