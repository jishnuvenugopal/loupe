
module TopModule (
    input  y[5:0],  
    input  w,       
    output Y1,     
    output Y3      
);

    
    typedef enum { A, B, C, D, E, F } state_t;

    
    state_t current_state;

    
    always @(posedge w) begin
        case (current_state)
            A: begin
                if (w) current_state = B;
                else current_state = A;
            end
            B: begin
                if (w) current_state = C;
                else current_state = D;
            end
            C: begin
                if (w) current_state = E;
                else current_state = D;
            end
            D: begin
                if (w) current_state = F;
                else current_state = A;
            end
            E: begin
                if (w) current_state = E;
                else current_state = D;
            end
            F: begin
                if (w) current_state = C;
                else current_state = D;
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                Y1 = y[1];
                Y3 = y[3];
            end
            B: begin
                Y1 = y[1];
                Y3 = y[3];
            end
            C: begin
                Y1 = y[1];
                Y3 = y[3];
            end
            D: begin
                Y1 = y[1];
                Y3 = y[3];
            end
            E: begin
                Y1 = y[1];
                Y3 = y[3];
            end
            F: begin
                Y1 = y[1];
                Y3 = y[3];
            end
        endcase
    end

endmodule
