
module TopModule (
    input  wire y[7:0],  
    input  wire w,       
    output wire Y1,      
    output wire Y3       
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    always_comb begin
        case (y)
            8'b000001: current_state = A;
            8'b000010: current_state = B;
            8'b000100: current_state = C;
            8'b001000: current_state = D;
            8'b010000: current_state = E;
            8'b100000: current_state = F;
            default: current_state = A;
  
        endcase
    end

    
    always_comb begin
        case (current_state)
            A: next_state = (w == 0) ? B : A;
            B: next_state = (w == 0) ? C : D;
            C: next_state = (w == 0) ? E : D;
            D: next_state = (w == 0) ? F : A;
            E: next_state = (w == 0) ? E : D;
            F: next_state = (w == 0) ? C : D;
        endcase
    end

    
    always_comb begin
        Y1 = y[1];
        Y3 = y[3];
    end

endmodule
