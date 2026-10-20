
module TopModule (
    input  y[5:0],  
    input  w,        
    output Y1,      
    output Y3       
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = A;
    end

    
    always @(posedge w) begin
        case (current_state)
            A: if (w) next_state = B;
 else next_state = A;
            B: if (w) next_state = C;
 else next_state = D;
            C: if (w) next_state = E;
 else next_state = D;
            D: if (w) next_state = F;
 else next_state = A;
            E: if (w) next_state = E;
 else next_state = D;
            F: if (w) next_state = C;
 else next_state = D;
        endcase
    end

    
    always @(*) begin
        Y1 = y[1];
  
        Y3 = y[3];
  
    end

    
    always @(posedge w) begin
        current_state <= next_state;
    end

endmodule
