
module TopModule (
    input  y,       
    input  w,       
    output Y1      
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    initial current_state = A;

    
    always @(posedge y or posedge w) begin
        case (current_state)
            A: begin
                if (y[1] == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (y[1] == 0) next_state = C;
                else next_state = D;
            end
            C: begin
                if (y[1] == 0) next_state = E;
                else next_state = D;
            end
            D: begin
                if (y[1] == 0) next_state = F;
                else next_state = A;
            end
            E: begin
                if (y[1] == 0) next_state = E;
                else next_state = D;
            end
            F: begin
                if (y[1] == 0) next_state = C;
                else next_state = D;
            end
        endcase
    end

    
    always @(posedge w) begin
        current_state <= next_state;
    end

    
    assign Y1 = current_state[1];

endmodule
