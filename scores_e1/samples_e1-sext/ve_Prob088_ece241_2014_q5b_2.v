
module TopModule (
    input wire clk,
    input wire areset,
    input wire x,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t current_state;

    
    reg [1:0] output_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            output_reg <= 2'b00;
        end else begin
            case (current_state)
                A: begin
                    if (x == 0) begin
                        current_state <= A;
                        output_reg <= 2'b00;
                    end else begin
                        current_state <= B;
                        output_reg <= 2'b01;
                    end
                end
                B: begin
                    if (x == 0) begin
                        current_state <= B;
                        output_reg <= 2'b01;
                    end else begin
                        current_state <= A;
                        output_reg <= 2'b10;
                    end
                end
            endcase
        end
    end

    
    assign z = output_reg[1];

endmodule
