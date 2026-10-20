
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

    
    always @(posedge y[7] or posedge w) begin
        case (current_state)
            A: begin
                if (y[7] == 1'b0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (y[7] == 1'b0) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            C: begin
                if (y[7] == 1'b0) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (y[7] == 1'b0) begin
                    next_state = F;
                end else begin
                    next_state = A;
                end
            end
            E: begin
                if (y[7] == 1'b1) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            F: begin
                if (y[7] == 1'b1) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
        endcase
    end

    
    always @(posedge y[7] or posedge w) begin
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

    
    always @(posedge y[7] or posedge w) begin
        case (current_state)
            A: begin
                y[5:0] = 8'b000001;
            end
            B: begin
                y[5:0] = 8'b000010;
            end
            C: begin
                y[5:0] = 8'b000100;
            end
            D: begin
                y[5:0] = 8'b001000;
            end
            E: begin
                y[5:0] = 8'b010000;
            end
            F: begin
                y[5:0] = 8'b100000;
            end
        endcase
    end

endmodule
