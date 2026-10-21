
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    typedef enum {A, B, C} state_t;

    
    state_t current_state = A;
    state_t next_state;

    
    reg [2:0] state_reg;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= A;
            state_reg <= A;
        end else begin
            current_state <= next_state;
            state_reg <= current_state;
        end
    end

    always @(posedge clk or posedge resetn) begin
        case (current_state)
            A: begin
                if (r[0] == 1) begin
                    next_state = B;
                end else if (r[1] == 1) begin
                    next_state = C;
                end else if (r[2] == 1) begin
                    next_state = A;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (r[0] == 1) begin
                    next_state = B;
                end else if (r[1] == 1) begin
                    next_state = A;
                end else if (r[2] == 1) begin
                    next_state = A;
                end else begin
                    next_state = A;
                end
            end
            C: begin
                if (r[0] == 1) begin
                    next_state = C;
                end else if (r[1] == 1) begin
                    next_state = A;
                end else if (r[2] == 1) begin
                    next_state = A;
                end else begin
                    next_state = A;
                end
            end
        endcase
    end

    
    assign state_reg = current_state;

    
    assign g[0] = (current_state == A) & (r[0] == 1);
    assign g[1] = (current_state == B) & (r[1] == 1);
    assign g[2] = (current_state == C) & (r[2] == 1);

endmodule
