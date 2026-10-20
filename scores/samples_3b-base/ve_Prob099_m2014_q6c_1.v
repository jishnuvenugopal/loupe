
module TopModule (
    input  y[7:0],  
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

    
    always @(*) begin
        Y1 = y[1];
        Y3 = y[3];
    end

endmodule
