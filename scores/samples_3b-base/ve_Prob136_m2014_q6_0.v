
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t current_state, next_state;

    
    wire z_wire;

    
    initial begin
        current_state = A;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state = A;
            z_wire = 0;
        end else begin
            current_state = next_state;
            z_wire = (current_state == E) ? 1'b1 : 1'b0;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w == 0) next_state = C;
                else next_state = A;
            end
            C: begin
                if (w == 0) next_state = D;
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

    
    assign z = z_wire;

endmodule
