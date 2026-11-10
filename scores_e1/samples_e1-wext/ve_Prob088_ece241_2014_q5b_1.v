
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t current_state;

    
    state_t next_state;

    
    reg [1:0] output_reg;

    
    initial begin
        current_state = A;
        output_reg = 2'b00;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            output_reg <= 2'b00;
        end else begin
            case (current_state)
                A: begin
                    if (x == 0) begin
                        next_state = A;
                        output_reg <= 2'b00;
                    end else begin
                        next_state = B;
                        output_reg <= 2'b01;
                    end
                end
                B: begin
                    if (x == 0) begin
                        next_state = B;
                        output_reg <= 2'b01;
                    end else begin
                        next_state = A;
                        output_reg <= 2'b10;
                    end
                end
            endcase
            current_state <= next_state;
        end
    end

    
    assign z = output_reg[1];

endmodule
