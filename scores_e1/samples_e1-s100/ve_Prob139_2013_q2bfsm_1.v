
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    typedef enum {state_A, state_B, state_C} state_t;

    
    state_t current_state;

    
    reg [2:0] x_counter;

    
    reg [1:0] y_counter;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= state_A;
            x_counter <= 3'b000;
            y_counter <= 2'b00;
            f <= 0;
            g <= 0;
        end else begin
            case (current_state)
                state_A: begin
                    if (x == 1) begin
                        x_counter <= x_counter + 1;
                    end else begin
                        x_counter <= 3'b000;
                    end
                    if (x_counter == 3'b011) begin
                        current_state <= state_B;
                    end
                end
                state_B: begin
                    if (x == 1) begin
                        x_counter <= x_counter + 1;
                    end else begin
                        x_counter <= 3'b000;
                    end
                    if (x_counter == 3'b011) begin
                        current_state <= state_C;
                    end
                end
                state_C: begin
                    if (y == 1) begin
                        g <= 1;
                        y_counter <= y_counter + 1;
                    end else begin
                        g <= 0;
                        y_counter <= 2'b00;
                    end
                    if (y_counter == 2'b01) begin
                        current_state <= state_A;
                    end
                end
            endcase
        end
    end

endmodule
