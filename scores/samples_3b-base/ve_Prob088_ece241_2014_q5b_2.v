
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

    
    always @(posedge clk) begin
        case (state_reg)
            A: begin
                if (x == 0) begin
                    z <= 0;
 
                end else begin
                    z <= 1;
 
                    next_state <= B;
 
                end
            end
            B: begin
                if (x == 0) begin
                    z <= 1;
 
                end else begin
                    z <= 0;
 
                    next_state <= B;
 
                end
            end
            default: begin
                
                z <= 0;
                next_state <= A;
            end
        endcase
    end

endmodule
