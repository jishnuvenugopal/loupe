
module TopModule (
    input  y[7:0],  
    input  w,       
    output reg Y1,    
    output reg Y3    
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    always @(posedge y[5:0] or posedge w) begin
        case (current_state)
            A: begin
                if (w == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w == 0) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
        endcase
    end

    
    always @(*) begin
        Y1 = y[0];
        Y3 = y[1];
    end

    
    always @(posedge y[5:0]) begin
        if (y[5:0] == 8'h00) current_state = A;
    end

    
    always @(posedge y[5:0] or posedge w) begin
        current_state <= next_state;
    end

endmodule
