
module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    typedef enum {A, B} state_t;
    state_t current_state, next_state;

    
    reg [1:0] state_reg;

    
    reg z_reg;

    
    initial begin
        state_reg <= A;
        z_reg <= 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= A;
            z_reg <= 0;
        end else begin
            current_state <= state_reg;
            next_state <= A;
 

            if (current_state == A) begin
                if (x == 0) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end else if (current_state == B) begin
                if (x == 0) begin
                    next_state <= B;
                end else begin
                    next_state <= A;
                end
            end
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z_reg <= 0;
        end else begin
            z_reg <= next_state;
        end
    end

    
    assign z = z_reg;

endmodule
