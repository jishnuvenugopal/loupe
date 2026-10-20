
module TopModule (
    input  y[7:0],  
    input  w,       
    output Y1,     
    output Y3      
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    assign current_state = {y[5], y[4], y[3], y[2], y[1], y[0]};

    
    always @(posedge w or posedge y[7:0]) begin
        case (current_state)
            A: begin
                if (y[7] == 1'b0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (y[7] == 1'b0) next_state = C;
                else next_state = D;
            end
            C: begin
                if (y[7] == 1'b0) next_state = E;
                else next_state = D;
            end
            D: begin
                if (y[7] == 1'b0) next_state = F;
                else next_state = A;
            end
            E: begin
                if (y[7] == 1'b1) next_state = E;
                else next_state = D;
            end
            F: begin
                if (y[7] == 1'b1) next_state = C;
                else next_state = D;
            end
        endcase
    end

    
    assign Y1 = y[1];
    assign Y3 = y[3];

endmodule
