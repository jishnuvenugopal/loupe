
module TopModule (
    input  y[5:0],  
    input  w,       
    output Y1,      
    output Y3       
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    always @(*) begin
        case (y)
            6'b000001: current_state = A;
            6'b000010: current_state = B;
            6'b000100: current_state = C;
            6'b001000: current_state = D;
            6'b010000: current_state = E;
            6'b100000: current_state = F;
            default: current_state = A;
 
        endcase
    end

    
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
 
        endcase
    end

    
    always @(*) begin
        Y1 = next_state[1];
  
        Y3 = next_state[3];
  
    end

    
    always @(posedge w) begin
        current_state <= next_state;
    end

endmodule
