
module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    typedef enum {A, B} state_t;
    state_t current_state, next_state;

    
    reg [1:0] state_reg;

    
    initial begin
        state_reg = A;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= A;
 
        end else begin
            state_reg <= next_state;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
 
        end else begin
            case (state_reg)
                A: begin
                    z <= 1'b0;
 
                end
                B: begin
                    z <= x;
 
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            next_state <= A;
 
        end else begin
            case (state_reg)
                A: begin
                    if (x == 0) begin
                        next_state <= A;
 
                    end else begin
                        next_state <= B;
 
                    end
                end
                B: begin
                    if (x == 0) begin
                        next_state <= B;
 
                    end else begin
                        next_state <= B;
 
                    end
                end
            endcase
        end
    end

endmodule
