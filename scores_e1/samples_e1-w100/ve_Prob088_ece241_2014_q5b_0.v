
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    typedef enum {A, B} state_t;

    
    reg [1:0] current_state;

    
    reg [1:0] state_A;
    reg [1:0] state_B;

    
    reg [1:0] output_A;
    reg [1:0] output_B;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            state_A <= 2'b00;
            state_B <= 2'b00;
            output_A <= 2'b00;
            output_B <= 2'b00;
        end else begin
            case (current_state)
                A: begin
                    if (x == 0) begin
                        current_state <= A;
                        state_A <= 2'b00;
                        state_B <= 2'b00;
                        output_A <= 2'b00;
                        output_B <= 2'b00;
                    end else begin
                        current_state <= B;
                        state_A <= 2'b01;
                        state_B <= 2'b00;
                        output_A <= 2'b01;
                        output_B <= 2'b00;
                    end
                end
                B: begin
                    if (x == 0) begin
                        current_state <= B;
                        state_A <= 2'b00;
                        state_B <= 2'b00;
                        output_A <= 2'b00;
                        output_B <= 2'b00;
                    end else begin
                        current_state <= A;
                        state_A <= 2'b00;
                        state_B <= 2'b01;
                        output_A <= 2'b00;
                        output_B <= 2'b01;
                    end
                end
            endcase
        end
    end

    
    assign z = output_A;

endmodule
